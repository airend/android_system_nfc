LOCAL_PATH:= $(call my-dir)
NFA := src/nfa
NFC := src/nfc
HAL := src/hal
UDRV := src/udrv
HALIMPL := halimpl/bcm2079x
D_CFLAGS := -DBUILDCFG=1 \
    -Wno-deprecated-register \
    -Wno-unused-parameter \
    -Wno-missing-field-initializers \


######################################
# Build shared library system/lib/hw/nfc_nci.*.so for Hardware Abstraction Layer.
# Android's generic HAL (libhardware.so) dynamically loads this shared library.

include $(CLEAR_VARS)
LOCAL_MODULE := nfc_nci.bcm2079x.default
LOCAL_PROPRIETARY_MODULE := true
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_POST_INSTALL_CMD := $(hide) ln -s $(LOCAL_MODULE).so \
    $(TARGET_OUT_VENDOR_SHARED_LIBRARIES)/$(LOCAL_MODULE_RELATIVE_PATH)/nfc_nci.$(TARGET_DEVICE).so
LOCAL_SRC_FILES := $(call all-c-files-under, $(HALIMPL)) \
    $(call all-cpp-files-under, $(HALIMPL)) \
    src/adaptation/CrcChecksum.cpp \
    src/nfca_version.c
LOCAL_SHARED_LIBRARIES := libcutils liblog libhwbinder
LOCAL_HEADER_LIBRARIES := libhardware_headers libhardware_legacy_headers
LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/$(HALIMPL)/include \
    $(LOCAL_PATH)/$(HALIMPL)/gki/ulinux \
    $(LOCAL_PATH)/$(HALIMPL)/gki/common \
    $(LOCAL_PATH)/$(HALIMPL)/adaptation \
    $(LOCAL_PATH)/$(HAL)/include \
    $(LOCAL_PATH)/$(HAL)/int \
    $(LOCAL_PATH)/$(NFC)/include \
    $(LOCAL_PATH)/$(NFA)/include \
    $(LOCAL_PATH)/$(UDRV)/include \
    $(LOCAL_PATH)/src/include
LOCAL_CFLAGS := $(D_CFLAGS) -DNFC_HAL_TARGET=TRUE -DNFC_RW_ONLY=TRUE
include $(BUILD_SHARED_LIBRARY)


######################################
include $(call all-makefiles-under,$(LOCAL_PATH))
