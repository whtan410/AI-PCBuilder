import axios, { AxiosInstance } from 'axios'
import { useAuthStore } from '@/stores/auth'
import router from '@/router'

  const useApi = (apiUrl = 'https://moonarch-api-service-220646501559.us-central1.run.app/'): AxiosInstance => {
  // const useApi = (apiUrl = 'http://127.0.0.1:8000'): AxiosInstance => {
    const instance = axios.create({
    baseURL: apiUrl,
    headers: {
      'Content-Type': 'application/json'
    }
  })

  // Request interceptor
  instance.interceptors.request.use(
    (config) => {
      const authStore = useAuthStore()
      const token = authStore.getToken
      
      if (token) {
        config.headers.Authorization = `Bearer ${token}`
      }
      return config
    },
    (error) => Promise.reject(error)
  )

  // Response interceptor
  instance.interceptors.response.use(
    (response) => response,
    async (error) => {
      const authStore = useAuthStore()
      
      if (error.response?.status === 401) {
        authStore.logout()
        if (router.currentRoute.value.path !== 'login') {
          router.push('/login')
        }
      }
      return Promise.reject(error)
    }
  )

  return instance
}

export default useApi