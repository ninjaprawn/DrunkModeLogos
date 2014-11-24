ARCHS = armv7 arm64
TARGET = iphone:clang:latest:latest
THEOS_BUILD_DIR = Packages

THEOS_DEVICE_IP=192.168.1.130

include theos/makefiles/common.mk

TWEAK_NAME = DrunkMode
DrunkMode_FILES = Tweak.xm
DrunkMode_FRAMEWORKS = UIKit
DrunkMode_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
