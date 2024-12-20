import { defineStore } from 'pinia'

export const useCheckoutStore = defineStore('checkout', {
    state: () => ({
        isCheckoutInitiated: false,
        checkoutData: null as any
    }),

    actions: {
        initiateCheckout(cartData: any) {
            this.isCheckoutInitiated = true
            this.checkoutData = cartData
        },
        clearCheckout() {
            this.isCheckoutInitiated = false
            this.checkoutData = null
        }
    }
})