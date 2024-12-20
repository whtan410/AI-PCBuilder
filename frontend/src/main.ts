/**
 * main.ts
 *
 * Bootstraps Vuetify and other plugins then mounts the App`
 */

// Plugins
import { registerPlugins } from '@/plugins'

// Components
import App from './App.vue'

// Composables
import { createApp } from 'vue'

import 'vuetify/styles'
import 'vuetify/dist/vuetify.min.css'
import '@mdi/font/css/materialdesignicons.css'

const app = createApp(App)
registerPlugins(app)
app.mount('#app')

// // FormKit imports
// import { plugin as formKitPlugin, defaultConfig } from '@formkit/vue'
// import { createMultiStepPlugin } from '@formkit/addons'
// import '@formkit/themes/genesis'
// import '@formkit/addons/css/multistep'

// app.use(formKitPlugin, defaultConfig({
//     plugins: [createMultiStepPlugin()]
//   }));