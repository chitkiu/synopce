//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <dsm_sdk/dsm_sdk_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) dsm_sdk_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "DsmSdkPlugin");
  dsm_sdk_plugin_register_with_registrar(dsm_sdk_registrar);
}
