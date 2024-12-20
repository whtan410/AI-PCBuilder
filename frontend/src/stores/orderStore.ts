import { defineStore } from 'pinia'
// import { useRouter } from 'vue-router'

import useApi from '../composables/useApi'

// import { useProductStore } from './productstore'
import { useCartStore } from './cartstore'
import { useCheckoutStore } from './checkoutStore'
import { useAuthStore } from './auth'


export const useOrderStore = defineStore('order', {
    state: () => ({
        isProcessing: false,
        error: null as string | null,
    }),

    actions: {
        async createOrder(formData: any, paymentDetails: any, orderSummary: any) {
            const cartStore = useCartStore()
            const checkoutStore = useCheckoutStore()
            const authStore = useAuthStore()
            // const router = useRouter()

            // Check if user is authenticated
            if (!authStore.isAuthenticated || !authStore.user) {
                throw new Error('User not authenticated')
            }

            try {
                this.isProcessing = true
                this.error = null
                console.log('Starting order creation...') // Debug log

                const orderData = {
                    user_id: authStore.user?.user_id,
                    order_status: 'Completed',
                    order_time: new Date().toISOString(),
                    
                    products: cartStore.cartItems
                        .filter(item => item.type === 'product')
                        .map(item => ({
                            product_id: item.item_id,
                            quantity: item.quantity
                        })),
                        
                    prebuilt_items: cartStore.cartItems
                        .filter(item => item.type === 'prebuilt')
                        .map(item => ({
                            build_id: item.item_id,
                            quantity: item.quantity
                        })),

                    delivery_info: {
                        street_address: formData.street_address,
                        city: formData.city,
                        state: formData.state,
                        postcode: formData.postcode,
                        country: 'Malaysia'
                    },

                    payment_info: {
                        payment_method: orderSummary.paymentMethod,
                        payment_reference: paymentDetails.refnum, //this part error, my fren
                        payment_status: 'Completed',
                        payment_time: new Date().toISOString()
                    }
                }

                console.log('Order data:', orderData) // Debug log

                const api = useApi()
                const response = await api.post('/orders/create', orderData)

                console.log('Response:', response.data) // Debug log

                // Clear cart and checkout data
                await cartStore.clearCart()
                cartStore.clearBuildIData()
                checkoutStore.clearCheckout()
                localStorage.removeItem('chatHistory')
                window.dispatchEvent(new Event('storage'))
                // Return success data
                return response.data

            } catch (error: any) {
                this.error = error.response?.data?.detail || 'Failed to create order'
                throw error
            } finally {
                this.isProcessing = false
            }
        }
    }
})