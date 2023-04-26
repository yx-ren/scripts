#/bin/bash
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

bash yum_install.sh
BCS_CHK_RC0 "failed to yum insall"

bash tools_install.sh
BCS_CHK_RC0 "failed to install tools"
