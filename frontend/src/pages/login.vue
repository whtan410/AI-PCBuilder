<template>
  <div class="login-container">
    <div class="login-card">
      <h1>{{ isLogin ? 'LOGIN' : 'SIGN UP' }}</h1>
      
      <form @submit.prevent="handleSubmit" ref="form">
        <div class="form-group">
          <label for="email">Email</label>
          <input 
            type="email" 
            id="email" 
            v-model="formData.email" 
            required
            placeholder="Enter your email"
            :class="{ 'error': emailError }"
          >
          <span class="error-text" v-if="emailError">{{ emailError }}</span>
        </div>

        <div class="form-group">
          <label for="password">Password</label>
          <div class="password-field">
            <input 
              :type="showPassword ? 'text' : 'password'"
              id="password" 
              v-model="formData.password" 
              required
              placeholder="Enter your password"
              :class="{ 'error': passwordError }"
            >
            <i class="password-toggle" 
               :class="showPassword ? 'mdi mdi-eye' : 'mdi mdi-eye-off'"
               @click="showPassword = !showPassword">
            </i>
          </div>
          <span class="error-text" v-if="passwordError">{{ passwordError }}</span>
        </div>

        <div v-if="error" class="error-alert">
          {{ error }}
        </div>

        <button type="submit" class="submit-btn" :disabled="loading">
          {{ isLogin ? 'Login' : 'Sign Up' }}
          <span v-if="loading" class="loader"></span>
        </button>
      </form>

      <p class="toggle-text">
        {{ isLogin ? "Don't have an account?" : "Already have an account?" }}
        <a href="#" @click.prevent="toggleMode">
          {{ isLogin ? 'Sign Up' : 'Login' }}
        </a>
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
  import { ref, reactive, computed } from 'vue'
  import { useAuthStore } from '@/stores/auth'
  import { useRouter } from 'vue-router'

  const router = useRouter()
  const authStore = useAuthStore()

  const isLogin = ref(true)
  const showPassword = ref(false)
  // const showConfirmPassword = ref(false)
  const loading = ref(false)
  const error = ref('')
  const form = ref<any>(null)

  const formData = reactive({
    email: '',
    password: '',
    confirmPassword: ''
  })

  // Computed error properties
  const emailError = computed(() => {
    if (!formData.email) return ''
    return /.+@.+\..+/.test(formData.email) ? '' : 'Please enter a valid email'
  })

  const passwordError = computed(() => {
    if (!formData.password) return ''
    return formData.password.length >= 4 ? '' : 'Password must be at least 4 characters'
  })

  const confirmPasswordError = computed(() => {
    if (!formData.confirmPassword || isLogin.value) return ''
    return formData.password === formData.confirmPassword ? '' : 'Passwords do not match'
  })

  const toggleMode = () => {
    isLogin.value = !isLogin.value
    error.value = ''
    formData.email = ''
    formData.password = ''
    formData.confirmPassword = ''
  }

  const handleSubmit = async () => {
    // Validate form
    if (emailError.value || passwordError.value || (!isLogin.value && confirmPasswordError.value)) {
      return
    }

    loading.value = true
  error.value = ''

    try {
      if (isLogin.value) {
        await authStore.login(formData.email, formData.password)
      } else {
        await authStore.signup(formData)
      }
    
    // Get redirect path from route query
      const redirect = router.currentRoute.value.query.redirect as string
      const from = router.currentRoute.value.query.from as string
    // Decide where to redirect
      if (redirect && from === 'customise') {
        router.push('/customise')
      } else {
        if (authStore.isMaster) {
          router.push('/admin')
        } else {
          router.push('/')
        }
      }
    } catch (err: any) {
      error.value = err.response?.data?.detail || 
        `${isLogin.value ? 'Login' : 'Sign up'} failed. Please try again.`
    } finally {
      loading.value = false
    }
  }
</script>

<style scoped>
  @import url('../assets/BitStreamFont/stylesheet.css');
  @import url('../assets/BPdotsFont/stylesheet.css');
  @import url('https://cdn.jsdelivr.net/npm/@mdi/font@6.x/css/materialdesignicons.min.css');

  .login-container {
    min-height: 97vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.6)), 
                url("https://mir-s3-cdn-cf.behance.net/project_modules/fs/223e6792880429.5e569ff84ebef.gif");
    background-attachment: fixed;
    background-size: cover;
    background-position: center;
  }

  .login-card {
    background-color: #3e0054;
    padding: 2rem;
    border-radius: 30px;
    box-shadow: 0px 0px 15px #E324BD;
    width: 100%;
    max-width: 400px;
    backdrop-filter: blur(5px);
  }

  h1 {
    text-align: center;
    margin-bottom: 2rem;
    color: #ffffff;
    font-family: 'bpdots';
    font-size: 3rem;
  }

  .form-group {
    margin-bottom: 1.5rem;
    position: relative;
  }

  label {
    display: block;
    margin-bottom: 0.5rem;
    color: #ffffff;
    font-family: 'bitstream';
  }

  .password-field {
    position: relative;
  }

  input {
    width: 100%;
    padding: 0.75rem;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 1rem;
    font-family: 'bitstream';
  }

  input.error {
    border-color: #ff4444;
  }

  .password-toggle {
    position: absolute;
    right: 10px;
    top: 50%;
    transform: translateY(-50%);
    cursor: pointer;
    color: #666;
  }

  .error-text {
    color: #ff4444;
    font-size: 0.8rem;
    margin-top: 0.25rem;
    font-family: 'bitstream';
  }

  .error-alert {
    background-color: #ff44447a;
    color: white;
    padding: 0.75rem;
    border-radius: 4px;
    margin-bottom: 1rem;
    font-family: 'bitstream';
  }

  .submit-btn {
    width: 100%;
    padding: 0.75rem;
    background-color: #001655;
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 1rem;
    cursor: pointer;
    transition: background-color 0.2s;
    font-family: 'bitstream';
    box-shadow: 0 0px 5px #E324BD;
    position: relative;
  }

  .submit-btn:hover {
    background-color: #E324BD;
  }

  .submit-btn:disabled {
    opacity: 0.7;
    cursor: not-allowed;
  }

  .loader {
    display: inline-block;
    width: 20px;
    height: 20px;
    border: 2px solid #ffffff;
    border-radius: 50%;
    border-top-color: transparent;
    animation: spin 1s linear infinite;
    margin-left: 10px;
  }

  @keyframes spin {
    to {
      transform: rotate(360deg);
    }
  }

  .toggle-text {
    text-align: center;
    margin-top: 1rem;
    font-family: 'bitstream';
    color: #ffffff;
  }

  a {
    color: #E324BD;
    text-decoration: none;
  }

  a:hover {
    text-decoration: underline;
  }
</style>

<route lang="yaml">
  name: auth
  meta:
    layout: auth
    guest: true
</route>