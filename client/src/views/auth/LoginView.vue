<template>
    <div id="app">
        <nav-bar />
        <section class="container py-0 py-md-2 py-lg-4" style="margin-top:72px">
            <div class="row py-5">
                <div class="col-12 col-md-8 col-lg-5 mx-auto">
                    <div class="px-3 py-3 px-md-4 px-lg-5 py-md-4 border border-3 border-secondary" style="border-radius:20px">
                        <h3 class="mb-3">Login</h3>    
                        <span v-if="this.errors.error">
                            <p class="text-danger fw-bold" v-html="this.errors.error"></p>
                        </span>               
                        <form id="loginForm" @submit.prevent="login" method="post">
                            <div class="form-group mb-4">
                                <label for="email" class="mb-2">Email</label>
                                <input type="text" name="email" v-model="user.email" class="form-control test" id="email">
                                <span class="text-danger fw-bolder" v-if="this.errors.email">
                                    <span v-text="this.errors.email"/>
                                </span>
                            </div>
                            <div class="form-group mb-4">
                                <label for="password" class="mb-2">Password</label>
                                <input type="password" name="password" v-model="user.password" class="form-control test" id="password">
                                <span class="text-danger fw-bolder" v-if="this.errors.password">
                                    <span v-text="this.errors.password"/>
                                </span>
                            </div>
                            <button class="btn login btn-secondary">Login</button>
                            <router-link to="/register" class="text-decoration-none d-inline-block ms-2">Create an account</router-link>
                            <span class="ps-2">|</span>
                            <router-link to="/forgot/password" onclick="window.location.reload(true);" class="text-decoration-none d-inline-block ms-2">Forgot Password</router-link>
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
        data() {
            return {
                token: localStorage.getItem("token"),
                user: {
                    email: '',
                    password: '',
                },
                errors: {
                    email: '',
                    password: '',
                    error: ''
                }
            }
        },
        created(){
            if(this.token != null){
                this.$router.push({name: 'home'});
            }
        },
        methods:{
            login(){
                this.axios.post('/login',this.user)
                .then(response => {
                    localStorage.setItem("token", response.data.token);
                    localStorage.setItem("current_user_id",response.data.user.id)
                    localStorage.setItem("current_user_name",response.data.user.name)
                    localStorage.setItem("current_user_email",response.data.user.email)
                    localStorage.setItem("current_user_image",response.data.user.image_data)
                    localStorage.setItem("current_user_role",response.data.user.role)
                    this.$router.push({name: 'postIndex'});
                    window.location.reload()
                })
                .catch(error => {
                    error.response.data.errors.email ? this.errors.email = error.response.data.errors.email : this.errors.email = ""
                    error.response.data.errors.password ? this.errors.password = error.response.data.errors.password : this.errors.password = ""
                    error.response.data.errors.error ? this.errors.error = error.response.data.errors.error : this.errors.error = ""
                })
            }
        }
    }
    $(document).ready(function(){
        $('.login').prop('disabled', true);

        $('#loginForm').keyup(function() {
            if($('#email').val() != "" && $('#password').val() != "") {
                $('.login').prop('disabled', false);
            } else {
                $('.login').prop('disabled', true);   
            }
        });
    })
</script>
