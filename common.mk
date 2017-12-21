PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/aost/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/aost/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/aost/prebuilt/common/bin/blacklist:system/addon.d/blacklist \
    vendor/aost/prebuilt/common/bin/whitelist:system/addon.d/whitelist \

# Bootanimation
#PRODUCT_COPY_FILES += \
#    vendor/aost/prebuilt/common/media/bootanimation.zip:system/media/bootanimation.zip

# init.d support
PRODUCT_COPY_FILES += \
    vendor/aost/prebuilt/common/bin/sysinit:system/bin/sysinit \
    vendor/aost/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/aost/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit

# Init file
PRODUCT_COPY_FILES += \
    vendor/aost/prebuilt/common/etc/init.local.rc:root/init.local.rc

# Bring in camera effects
PRODUCT_COPY_FILES +=  \
    vendor/aost/prebuilt/common/media/LMprec_508.emd:system/media/LMprec_508.emd \
    vendor/aost/prebuilt/common/media/PFFprec_600.emd:system/media/PFFprec_600.emd

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# Misc packages
PRODUCT_PACKAGES += \
    BluetoothExt \
    libemoji \
    libsepol \
    e2fsck \
    mke2fs \
    tune2fs \
    bash \
    Jelly \
    powertop \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    mkfs.f2fs \
    fsck.f2fs \
    fibmap.f2fs \
    mkfs.ntfs \
    fsck.ntfs \
    mount.ntfs \
    gdbserver \
    micro_bench \
    oprofiled \
    sqlite3 \
    strace \
    Terminal \
    WallpaperPicker

# Telephony packages
PRODUCT_PACKAGES += \
    messaging \
    CellBroadcastReceiver \
    Stk \
    telephony-ext

PRODUCT_BOOT_JARS += \
    telephony-ext

# RCS
PRODUCT_PACKAGES += \
    rcscommon \
    rcscommon.xml \
    rcsservice \
    rcs_service_aidl \
    rcs_service_aidl.xml \
    rcs_service_aidl_static \
    rcs_service_api \
    rcs_service_api.xml

# Snapdragon packages
PRODUCT_PACKAGES += \
    MusicFX \
    SnapdragonGallery \
    SnapdragonMusic

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# OMS
PRODUCT_PACKAGES += \
    ThemeInterfacer

# Mms depends on SoundRecorder for recorded audio messages
PRODUCT_PACKAGES += \
    SoundRecorder

# Custom off-mode charger
ifneq ($(WITH_CM_CHARGER),false)
PRODUCT_PACKAGES += \
    charger_res_images \
    cm_charger_res_images \
    font_log.png \
    libhealthd.cm
endif

# World APN list
PRODUCT_COPY_FILES += \
    vendor/aost/prebuilt/common/etc/apns-conf.xml:system/etc/apns-conf.xml

# Selective SPN list for operator number who has the problem.
PRODUCT_COPY_FILES += \
    vendor/aost/prebuilt/common/etc/selective-spn-conf.xml:system/etc/selective-spn-conf.xml

PRODUCT_PACKAGE_OVERLAYS += \
	vendor/aost/overlay/common

# Proprietary latinime libs needed for Keyboard swyping
ifneq ($(filter arm64,$(TARGET_ARCH)),)
PRODUCT_COPY_FILES += \
    vendor/aost/prebuilt/common/lib/libjni_latinime.so:system/lib/libjni_latinime.so
else
PRODUCT_COPY_FILES += \
    vendor/aost/prebuilt/common/lib64/libjni_latinime.so:system/lib64/libjni_latinime.so
endif

# by default, do not update the recovery with system updates
PRODUCT_PROPERTY_OVERRIDES += persist.sys.recovery_update=false

#ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
#ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
#endif


PRODUCT_VERSION_MAJOR = 1
PRODUCT_VERSION_MINOR = 0

# Set AOST_BUILDTYPE from the env RELEASE_TYPE

ifndef AOST_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "AOST_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^AOST_||g')
        AOST_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Filter out random types, so it'll reset to UNOFFICIAL
ifeq ($(filter RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL,$(AOST_BUILDTYPE)),)
    AOST_BUILDTYPE :=
endif

ifdef AOST_BUILDTYPE
    ifneq ($(AOST_BUILDTYPE), SNAPSHOT)
        ifdef AOST_EXTRAVERSION
            # Force build type to EXPERIMENTAL
            AOST_BUILDTYPE := EXPERIMENTAL
            # Remove leading dash from AOST_EXTRAVERSION
            AOST_EXTRAVERSION := $(shell echo $(AOST_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to AOST_EXTRAVERSION
            AOST_EXTRAVERSION := -$(AOST_EXTRAVERSION)
        endif
    else
        ifndef AOST_EXTRAVERSION
            # Force build type to EXPERIMENTAL, SNAPSHOT mandates a tag
            AOST_BUILDTYPE := EXPERIMENTAL
        else
            # Remove leading dash from AOST_EXTRAVERSION
            AOST_EXTRAVERSION := $(shell echo $(AOST_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to AOST_EXTRAVERSION
            AOST_EXTRAVERSION := -$(AOST_EXTRAVERSION)
        endif
    endif
else
    # If AOST_BUILDTYPE is not defined, set to UNOFFICIAL
    AOST_BUILDTYPE := UNOFFICIAL
    AOST_EXTRAVERSION :=
endif

ifeq ($(AOST_BUILDTYPE), UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        AOST_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

ifeq ($(AOST_BUILDTYPE), RELEASE)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
        AOST_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(AOST_BUILDTYPE)
    else
        ifeq ($(TARGET_BUILD_VARIANT),user)
            ifeq ($(AOST_VERSION_MAINTENANCE),0)
                AOST_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(AOST_BUILDTYPE)
            else
                AOST_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(AOST_BUILDTYPE)
            endif
        else
            AOST_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(AOST_BUILDTYPE)
        endif
    endif
else
    ifeq ($(AOST_VERSION_MAINTENANCE),0)
        ifeq ($(AOST_BUILDTYPE), UNOFFICIAL)
            AOST_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d_%H%M%S)-$(AOST_BUILDTYPE)
        else
            AOST_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d)-$(AOST_BUILDTYPE)-$(AOST_BUILDTYPE)
        endif
    else
        ifeq ($(AOST_BUILDTYPE), UNOFFICIAL)
            AOST_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d_%H%M%S)-$(AOST_BUILDTYPE)
        else
            AOST_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d)-$(AOST_BUILDTYPE)
        endif
    endif
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.com.google.clientidbase=android-google \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false \
    ro.opa.eligible_device=true \
    ro.setupwizard.rotation_locked=true \
    ro.caf.version=$(shell grep "<default revision=" .repo/manifest.xml | awk -F'"' '{print $$2}' | awk  -F "/" '{print $$3}') \
    ro.aosp-caf.version=$(shell grep "/AOSP-CAF" -A1 .repo/manifest.xml | tail -1 | awk -F'"' '{print $$2}' | awk -F "/" '{print $$3}') \
    ro.aost.version=$(AOST_VERSION)

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

$(call inherit-product-if-exists, vendor/extra/product.mk)
