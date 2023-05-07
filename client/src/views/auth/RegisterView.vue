<template>
    <div id="app">
        <div v-if="this.currentUerRole == 'admin'">
            <login-nav />
        </div>
        <div v-else>
            <nav-bar />
        </div>
        <div class="container py-0 py-md-2 py-lg-4" style="margin-top:72px">
            <div class="row py-4">
                <div class="col-12 col-lg-8 mx-auto">
                    <div class="px-3 py-3 px-md-4 px-lg-5 py-md-4 border border-3 border-secondary" style="border-radius:20px">
                        <h3 v-if="this.currentUerRole == 'admin'" class="mb-3">Create User</h3>
                        <h3 v-else class="mb-3">Sign Up</h3>
                        <form @submit.prevent="register" method="post">
                            <div class="row">
                                <div class="col-12 col-md-6 mb-4">
                                    <div class="from-group">
                                        <label for="name" class="mb-2">Name</label>
                                        <input type="text" name="name" v-model="form.name" placeholder="Your Name" class="form-control">
                                        <span class="text-danger fw-bolder" v-if="this.error.name">
                                            Name <span v-text="this.error.name"/>
                                        </span>
                                    </div>
                                </div>
                                <div class="col-12 col-md-6 mb-4">
                                    <div class="form-group">
                                        <label for="email" class="mb-2">Email</label>
                                        <input type="text" name="email" v-model="form.email" placeholder="Your Email(example@gmail.com)" class="form-control">
                                        <span class="text-danger fw-bolder" v-if="this.error.email">
                                            Email <span v-text="this.error.email"/>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-12 col-md-6 mb-4">
                                    <div class="from-group">
                                        <label for="password" class="mb-2">Password</label>
                                        <input type="password" name="passwrod" v-model="form.password" placeholder="Password" class="form-control">
                                        <span class="text-danger fw-bolder" v-if="this.error.password">
                                            Password <span v-text="this.error.password"/>
                                        </span>
                                    </div>
                                </div>
                                <div class="col-12 col-md-6 mb-4">
                                    <div class="form-group">
                                        <label for="password_confirmation" class="mb-2">Confirm Password</label>
                                        <input type="password" name="password_confrmation" v-model="form.password_confirmation" placeholder="Confirm Password" class="form-control">
                                        <span class="text-danger fw-bolder" v-if="this.error.password_confirmation">
                                            Password Confirmation <span v-text="this.error.password_confirmation"/>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="row" v-if="currentUerRole == 'admin'">
                                <div class="form-group mb-4">
                                    <label for="role" class="mb-2">Role</label>
                                    <select v-model="form.role" class="form-select">
                                        <option value="" selected disabled>Select Role</option>
                                        <option value="admin">Admin</option>
                                        <option value="user">User</option>
                                    </select>
                                    <span class="text-danger fw-bolder" v-if="this.error.role">
                                        Role <span v-text="this.error.role"/>
                                    </span>
                                </div>
                            </div>
                            <input v-else type="hidden" v-model="form.role">
                            <div class="row mb-4">
                                <div class="from-group">
                                    <label for="bio" class="mb-2">Bio</label>
                                    <textarea name="bio" id="" v-model="form.bio" class="form-control w-100" rows="3" placeholder="Your Bio"></textarea>
                                    <span class="text-danger fw-bolder" v-if="this.error.bio">
                                        Bio <span v-text="this.error.bio"/>
                                    </span>
                                </div>
                            </div>
                            <button v-if="this.currentUerRole == 'admin'" type="submit" class="btn btn-secondary">Create</button>
                            <button v-else type="submit" class="btn btn-secondary">Sign Up</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import LoginNav from '../../components/Common/LoginNav.vue';
import NavBar from '../../components/Common/NavBar.vue'

    export default {
        components: { NavBar, LoginNav },
        data(){
            return{
                token: localStorage.getItem("token"),
                currentUerRole: localStorage.getItem("current_user_role"),
                form: {
                    name: this.name,
                    email: this.email,
                    password: this.password,
                    role: 'user',
                    confirm_password: this.confirm_password,
                    bio: this.bio,
                },
                error: {
                    name: "", 
                    email: "",
                    password: "",
                    role: "",
                    confirm_password: "",
                    bio: "" 
                },
            }
        },
        created(){
            if(this.token != null && this.currentUerRole != 'admin'){
                this.$router.push({name: 'home'});
            }
        },
        methods: {
            register(){
                this.axios.post('/users', this.form)
                .then(() => { 
                    if(this.currentUerRole == 'admin'){
                        this.$router.push({name: 'users'});
                    }else{
                        this.$router.push({name: 'login'});
                    }
                })
                .catch(error => {
                    this.error.name = "";
                    this.error.email = "";
                    this.error.password = "";
                    this.error.role = "";
                    this.error.password_confirmation = "";
                    this.error.bio = "";
                    error.response.data.error.name ? this.error.name = error.response.data.error.name[0] : this.error.name='';
                    error.response.data.error.role ? this.error.role = error.response.data.error.role[0] : this.error.role='';
                    error.response.data.error.email ? this.error.email = error.response.data.error.email[0] : this.error.email='';
                    error.response.data.error.password ? this.error.password = error.response.data.error.password[0] : this.error.password='';
                    error.response.data.error.password_confirmation ? this.error.password_confirmation = error.response.data.error.password_confirmation[0] : this.error.password_confirmation='';
                    error.response.data.error.bio ? this.error.bio = error.response.data.error.bio[0] : this.error.bio='';
                })
            },
        }
    }
    
</script>