import { defineStore } from "pinia";
import useApi from "../composables/useApi";

interface UserInfo {
    email: string;
    full_name: string | null;
    phone_number: string | null;
    street_address: string | null;
    city: string | null;
    state: string | null;
    postcode: string | null;
    country: string | null;
}

interface ProfileUpdate {
    full_name?: string;
    phone_number?: string;
    street_address?: string;
    city?: string;
    state?: string;
    postcode?: string;
    country?: string;
}

interface OrderItem {
    product_name: string;
    category: string;
    quantity: number;
    price: number;
    type: 'product' | 'prebuilt';
}

interface PasswordInfo {
    old_password: string;
    new_password: string;
    confirm_password: string;
}

interface Feedback {
    rating: number;
    platform: 'Facebook' | 'Youtube' | 'Twitter' | 'Instagram' | 'Tiktok';
}

interface OrdersInfo {
    order_id: string;
    order_time: string;
    order_status: string;
    items: OrderItem[];
    feedback?: Feedback; // Add this field
}

export const useUserProfileStore = defineStore("userprofile", {
    state: () => ({
        userInfo: {
            email: '',
            full_name: null,
            phone_number: null,
            street_address: null,
            city: null,
            state: null,
            postcode: null,
            country: null
        } as UserInfo,
        ordersInfo: [] as OrdersInfo[],
        passwordInfo: {
            old_password: '',
            new_password: '',
            confirm_password: ''
        } as PasswordInfo,
        ratingInfo: {
            rating: 0,
            platform: '' as Feedback['platform']
        } as Feedback
    }),

    actions: {
        async fetchUserInfo(): Promise<UserInfo> {
            try {
                const api = useApi();
                const response = await api.get("/user/profile");
                this.userInfo = response.data
                return this.userInfo;
            } catch (error) {
                console.error('Error fetching user info:', error);
                throw error;
            }
        },

        async updateUserInfo(profileData: ProfileUpdate): Promise<void> {
            try {
                const api = useApi();
                await api.put("/user/profile", profileData);
                await this.fetchUserInfo();
            } catch (error) {
                console.error('Error updating user info:', error);
                throw error;
            }
        },

        async updateUserPassword(passwordData: PasswordInfo): Promise<void> {
            try {
                const api = useApi();
                await api.put("/user/change-password", passwordData);
            } catch (error) {
                console.error('Error updating password:', error);
                throw error;
            }
        },

        async fetchOrders(): Promise<OrdersInfo[]> {
            try {
                const api = useApi();
                const response = await api.get("/user/orders");
                this.ordersInfo = response.data;
                return this.ordersInfo;
            } catch (error) {
                console.error('Error fetching orders:', error);
                throw error;
            }
        },

        async submitOrderRating(orderId: string, feedback: Feedback): Promise<void> {
            try {
                const api = useApi();
                await api.post(`/user/orders/feedback/${orderId}`, feedback);
                // Refresh orders after submitting feedback
                await this.fetchOrders();
            } catch (error) {
                console.error('Error submitting rating:', error);
                throw error;
            }
        }
    }
})

