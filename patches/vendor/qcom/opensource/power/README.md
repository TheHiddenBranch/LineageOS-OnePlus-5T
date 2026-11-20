# Qualcomm power HAL

## `0001-resolve-msm8998-displayconfig-aidl.patch`

The legacy MSM8998 display namespace supplies headers but no DisplayConfig AIDL v12
module. Resolve that shared library from `vendor/qcom/opensource/commonsys-intf/display`
when MSM8998 headers are selected, avoiding Soong’s undefined-module error.
