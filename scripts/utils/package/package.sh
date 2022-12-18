# shellcheck shell=sh
# shellcheck disable=SC2039,SC2059

# Title:          package
# Description:    A library for package utils.
# License-SPDX:   MIT



##
# Check if package on device builds are supported by checking
# `$TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED` value in its `build.sh`
# file.
# .
# .
# **Parameters:**
# `package_dir` - The directory path for the package `build.sh` file.
# .
# **Returns:**
# Returns `0` if supported, otherwise `1`.
# .
# .
# pacakge__is_package_on_device_build_supported `package_dir`
##
pacakge__is_package_on_device_build_supported() {
	local TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED="$(. ${1}/build.sh; echo $TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED)"
	[ "$TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED" = "false" ]
	return $?
}



##
# Adds a package to the list of built packages if it is not in the list.
# .
# .
# **Parameters:**
# `package_name` - The name of the package.
# .
# .
# pacakge__add_package_to_built_packages_list
##
pacakge__add_package_to_built_packages_list() {
	echo "$TERMUX_BUILD_PACKAGE_CALL_BUILT_PACKAGES_LIST"
	if [[ " $TERMUX_BUILD_PACKAGE_CALL_BUILT_PACKAGES_LIST " != *" $1 "* ]]; then
		TERMUX_BUILD_PACKAGE_CALL_BUILT_PACKAGES_LIST+=" $1"
	fi
}
