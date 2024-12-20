import { defineStore } from "pinia";
import useApi from "../composables/useApi";

interface User {
    email : string;
    password : string;
    full_name : string;
    phone_number : string;
    address : string;
    user_type : string;
  }
  
export const useUserStore = defineStore("userstore", {
    state : () => ({
        users: [] as User[],
    }),

    actions : {
        async addUsers(user: User): Promise <void> {
            try { 
                const api = useApi();
                await api.post("/users", user);
            } catch (error) {
                console.error("Error saving book:", error);
                throw error;
            }   
        }
    }
})