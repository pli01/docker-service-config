#!/bin/bash
set -x
export image_name=${1:? $(basename $0) IMAGE_NAME VERSION needed}
export VERSION=${2:-latest}

echo "Display test config"
docker-compose config

echo "Check ansible version"
docker-compose run --name "test-service-config" --rm --entrypoint "/docker-entrypoint.sh"  service-config /usr/bin/ansible --version

echo "Check ansible syntax-check"
docker-compose run --name "test-service-config" --rm --entrypoint "/bin/bash -c"  service-config \
   "( cd /opt/ansible && /usr/bin/ansible-playbook -i config -c local -l localhost playbooks/site.yml --syntax-check  )"

echo "Check ansible list-tasks"
docker-compose run --name "test-service-config" --rm --entrypoint "/bin/bash -c"  service-config \
   "( cd /opt/ansible && /usr/bin/ansible-playbook -i config -c local -l localhost playbooks/site.yml --list-tasks )"

#( cd ../ansible && ansible-playbook -i config -c local -l localhost playbooks/site.yml --syntax-check  )
#( cd ../ansible && ansible-playbook -i config -c local -l localhost playbooks/site.yml --list-tasks  )
