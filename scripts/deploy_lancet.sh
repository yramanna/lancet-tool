#!/usr/bin/env bash

# MIT License
#
# Copyright (c) 2019-2021 Ecole Polytechnique Federale Lausanne (EPFL)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# In coordinator host, insert latest agent build to lancet_manager wheel
wheel unpack agent-manager/dist/lancet_manager-0.1.0-py3-none-any.whl
rm lancet_manager-0.1.0/manager/assets/agent
cp agents/assets/agents/agent lancet_manager-0.1.0/manager/assets/
wheel pack lancet_manager-0.1.0/
rm -rf lancet_manager-0.1.0
rm agent-manager/dist/lancet_manager-0.1.0-py3-none-any.whl
mv lancet_manager-0.1.0-py3-none-any.whl agent-manager/dist/

for hostname in `IFS=',' inarr=($1) && echo ${inarr[@]}`; do
	dirname=${2:-/tmp/`whoami`}/lancet
	ssh $hostname mkdir -p $dirname
	scp agent-manager/dist/lancet_manager-0.1.0-py3-none-any.whl $hostname:$dirname
	
	PACKAGE=virtualenv
	echo "→ Checking for package '${PACKAGE}' on ${hostname}..."
	if ssh -o BatchMode=yes "${hostname}" "dpkg -s ${PACKAGE}" &>/dev/null; then
		echo "✔ '${PACKAGE}' is already installed on ${hostname}."
	else
		echo "✖ '${PACKAGE}' is NOT installed. Installing now..."
		ssh "${hostname}" <<EOF
			set -e
			sudo apt-get update -y
			sudo apt-get install -y ${PACKAGE}
EOF
		echo "✔ '${PACKAGE}' has been installed on ${hostname}."
	fi

	ssh $hostname << EOF
	cd $dirname
	virtualenv -p python3 venv
	source venv/bin/activate && pip3 install $dirname/lancet_manager-0.1.0-py3-none-any.whl
EOF
done
