<template>
    <div id="app">
        <nav-bar />
        <section class="container py-0 py-md-2 py-lg-4" style="margin-top:72px">
            <div class="row py-5">
                <div class="col-12 col-md-8 col-lg-5 mx-auto">
                    <div class="px-3 py-3 px-md-4 px-lg-5 py-md-4 border border-3 border-secondary" style="border-radius:20px">
                        <h3 class="mb-3">Forgot Password</h3>                
                        <form @submit.prevent="forgot" method="post">
                            <div class="form-group mb-4">
                                <label for="email" class="mb-2">Enter Your Email Address</label>
                                <input type="text" name="email" v-model="user.email" class="form-control test" id="email">
                                <span class="text-danger fw-bolder" v-if="this.error.email">
                                    <span v-text="this.error.email"/>
                                </span>
                            </div>
                            <button class="btn continue btn-secondary">Continue</button>
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
import Swal from "sweetalert2";
const Toast = Swal.mixin({
  toast: true,
  position: 'top-end',
  showConfirmButton: false,
  timer: 3000,
  timerProgressBar: true,
  didOpen: (toast) => {
    toast.addEventListener('mouseenter', Swal.stopTimer)
    toast.addEventListener('mouseleave', Swal.resumeTimer)
  }
});

export default {
    components: { NavBar },
    data(){
        return{
            user: {
                email: '',
            },
            error: {
                email: '',
            }
        }
    },
    methods:{
      forgot(){
        this.axios.post('/user/forgot/password',this.user)
        .then(res => {
            localStorage.setItem('forgot_user_id', res.data.id)
            Toast.fire({
                icon: 'success',
                title: 'Eamil Sent successfully!'
            });  
            this.user.email = ''
        })
        .catch(error =>{
            console.log(error)
            error.response.data ? this.error.email = error.response.data : this.error.email = ''
        })
      }  
    }
}
$(document).ready(function(){
        $('.continue').prop('disabled', true);

        $('#email').keyup(function() {
            if($(this).val() != "") {
                $('.continue').prop('disabled', false);
            } else {
                $('.continue').prop('disabled', true);   
            }
        });
    })
</script>