<template>
    <div id="app">
        <nav-bar />
        <section class="container py-0 py-md-2 py-lg-4" style="margin-top:72px">
            <div class="row py-5">
                <div class="col-12 col-md-8 col-lg-5 mx-auto">
                    <div class="px-3 py-3 px-md-4 px-lg-5 py-md-4 border border-3 border-secondary" style="border-radius:20px">
                        <h3 class="mb-3">Reset Password</h3>                
                        <form id="reset" @submit.prevent="reset" method="post">
                            <div class="form-group mb-4">
                                <label for="password" class="mb-2">New Password</label>
                                <input type="password" name="password" v-model="user.password" class="form-control test" id="password">
                            </div>
                            <div class="form-group mb-4">
                                <label for="password_confirmation" class="mb-2">Confirm Password</label>
                                <input type="password" id="password_confirmation" v-model="user.password_confirmation" class="form-control">
                                <span class="text-danger fw-bolder" v-if="this.error.password_confirmation">
                                    Password Confirmation <span v-text="this.error.password_confirmation"/>
                                </span>
                            </div>
                            <button class="btn change btn-secondary">Change</button>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </div>
</template>

<script>
import NavBar from '../../components/Common/NavBar.vue'
import $ from 'jquery'

export default {
    components: { NavBar },
    data(){
        return{
            user: {
                password: '',
                password_confirmation: '',
            },
            forgot_user: localStorage.getItem('forgot_user_id'),
            error: {
                password_confirmation: '',
            }
        }
    },
    methods: {
        reset(){
            this.axios.patch(`/user/reset/password/${this.forgot_user}`,this.user)
            .then(() => {
                localStorage.removeItem('forgot_user_id')
                this.$router.push('/login')
            })
            .catch(error => {
                error.response.data.password_confirmation ? this.error.password_confirmation = error.response.data.password_confirmation[0] : this.error.password_confirmation = ''
            })
        }
    }
}
$(document).ready(function(){
        $('.change').prop('disabled', true);

        $('#reset').keyup(function() {
            if($('#password').val() != "" && $('#password_confirmation').val() != "") {
                $('.change').prop('disabled', false);
            } else {
                $('.change').prop('disabled', true);   
            }
        });
    })
</script>