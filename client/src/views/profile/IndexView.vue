<template>
    <div id="app">
        <div v-if="currentUserId"><login-nav /></div>
        <div v-else><nav-bar /></div>
        <section class="container" style="margin-top:72px">
            <div class="row">
                <div class="col-12 col-lg-8 blk py-5 mx-auto">
                    <div class="row mb-5 pe-0 pe-md-5">
                        <div class="col-12">
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="d-flex align-items-center">
                                    <div v-if="user.image_data == null">
                                        <img src="@/assets/user.png" width="70px" height="70px" class="rounded-circle me-2">
                                    </div>
                                    <div v-else>
                                        <img :src="`${axios.defaults.baseURL}/uploads/`+JSON.parse(user.image_data).id" width="70px" height="70px" class="rounded-circle me-2">
                                    </div>
                                    <p class="mb-0 fs-4 fs-md-3 fw-bold text-capitalize">{{ user.name }}</p>
                                </div>
                                <div class="d-none d-md-inline-block">
                                    <a v-if="currentUserId == user.id || currentUserRole =='admin'" href="" id="changeProfile" data-bs-toggle="modal" data-bs-target="#profileModal" class="d-inline-block"><span class="rounded-pill bg-secondary text-white d-inline-block px-2 me-2 px-md-4 py-1 py-md-2">Edit Profile</span></a>
                                    <a  v-if="currentUserId == user.id" href="" id="changePass" data-bs-toggle="modal" data-bs-target="#passwordModal" class="d-inline-block"><span class="rounded-pill bg-success text-white d-inline-block px-2 px-md-4 py-1 py-md-2">Change Password</span></a>
                                </div>
                                <div class="dropdown d-md-none">
                                    <button class="btn btn-white border-0" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none"><path fill-rule="evenodd" clip-rule="evenodd" d="M4.39 12c0 .55.2 1.02.59 1.41.39.4.86.59 1.4.59.56 0 1.03-.2 1.42-.59.4-.39.59-.86.59-1.41 0-.55-.2-1.02-.6-1.41A1.93 1.93 0 0 0 6.4 10c-.55 0-1.02.2-1.41.59-.4.39-.6.86-.6 1.41zM10 12c0 .55.2 1.02.58 1.41.4.4.87.59 1.42.59.54 0 1.02-.2 1.4-.59.4-.39.6-.86.6-1.41 0-.55-.2-1.02-.6-1.41a1.93 1.93 0 0 0-1.4-.59c-.55 0-1.04.2-1.42.59-.4.39-.58.86-.58 1.41zm5.6 0c0 .55.2 1.02.57 1.41.4.4.88.59 1.43.59.57 0 1.04-.2 1.43-.59.39-.39.57-.86.57-1.41 0-.55-.2-1.02-.57-1.41A1.93 1.93 0 0 0 17.6 10c-.55 0-1.04.2-1.43.59-.38.39-.57.86-.57 1.41z" fill="#000"></path></svg>
                                    </button>
                                    <ul class="dropdown-menu">
                                        <li>
                                            <router-link to="#" class="dropdown-item me-2">Edit Profile</router-link>
                                        </li>
                                        <li>
                                            <router-link to="#" class="dropdown-item">'Change Password</router-link>
                                        </li>
                                    </ul> 
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row ps-4 ps-md-5 pe-md-5">
                        <div class="col-12 pe-md-5">
                            <h4 class="pb-3 border-bottom border-dark-50">Information</h4>
                            <div class="pt-4 mb-4">
                                <p class="m-0 fs-6 fw-bold pb-2">Email</p>
                                <p>{{ user.email }}</p>
                            </div>
                            <div class="pt-2">
                                <p class="m-0 fs-6 fw-bold pb-2">Post Count</p>
                                <span class="rounded-pill d-inline-block text-white bg-secondary mb-3 px-2">{{ count }}</span>
                            </div>
                            <div class="pt-2 mb-4">
                                <p class="m-0 fs-6 fw-bold pb-2">Bio</p>
                                <p class="">{{ user.bio }}</p>
                            </div>
                        </div>
                    </div>
                    <div class="row ps-md-5">
                         <div class="col-12">
                            <h4 class="pb-3 pt-4 border-bottom border-dark-50">My Posts</h4>
                                <div v-for="post in posts" :key="post.id">
                                    <div class="pb-3 pt-4 border-bottom border-dark-50">
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="d-flex align-items-center mb-3">
                                                    <router-link :to="`/profile/`+post.user_id">
                                                        <div v-if="user.image_data == null">
                                                            <img src="@/assets/user.png" height="24px" width="24px" class="rounded-circle me-2">
                                                        </div>
                                                        <div v-else>
                                                            <img :src="`${axios.defaults.baseURL}/uploads/`+JSON.parse(getUser(post).image_data).id" height="24px" width="24px" class="rounded-circle me-2">
                                                        </div>
                                                    </router-link>
                                                    <router-link :to="`/profile/`+post.user_id" class="text-decoration-none text-black">
                                                        <p class="m-0"><span class="fs-6 me-1 fw-bold text-capitalize">{{ getUser(post).name }}</span><span class="me-1">.</span><span class="text-black-50"> {{ post.created_at | moment("from", "now", true)   }} ago</span></p>
                                                    </router-link>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row mb-3">
                                            <div class="col-8">
                                                <router-link :to="`/posts/`+post.id" class="text-decoration-none text-black">
                                                    <h4 class="fw-bolder">{{ post.title }}</h4>
                                                </router-link>
                                                <router-link :to="`/posts/`+post.id" class="text-decoration-none" style="color: rgba(41, 41, 41, 1)">
                                                    <p class="m-0 d-none d-md-block" style="line-height:1.7;text-align:justify;">
                                                        {{ post.description | truncate(200) }}
                                                    </p>
                                                </router-link>
                                            </div> 
                                            <div class="col-1"></div>
                                            <div class="col-3">
                                                <img :src="`${axios.defaults.baseURL}/uploads/`+ JSON.parse(post.image_data).id" class="img-fluid" width="150px" height="150px">
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-12 col-md-9">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <div class="align-items-end" style="color:rgba(117, 117, 117, 1);">
                                                        <router-link :to="`/category/`+getCategory(post).name" class="rounded-pill text-decoration-none d-inline-block px-3 pb-1" style="background-color: rgba(242, 242, 242, 1);color:rgba(117, 117, 117, 1);">{{ getCategory(post).name }}</router-link> <span class="mx-1">.</span> <span>9 min read</span> <span class="mx-1">.</span> <span class="d-none d-md-inline-block">Selected for you</span>
                                                    </div>
                                                    <div class="d-flex justify-content-between align-items-center fs-2">
                                                        <div v-if="post.user_id == currentUserId">
                                                            <div class="dropdown">
                                                                <button class="btn btn-white p-0 border-0" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none"><path fill-rule="evenodd" clip-rule="evenodd" d="M4.39 12c0 .55.2 1.02.59 1.41.39.4.86.59 1.4.59.56 0 1.03-.2 1.42-.59.4-.39.59-.86.59-1.41 0-.55-.2-1.02-.6-1.41A1.93 1.93 0 0 0 6.4 10c-.55 0-1.02.2-1.41.59-.4.39-.6.86-.6 1.41zM10 12c0 .55.2 1.02.58 1.41.4.4.87.59 1.42.59.54 0 1.02-.2 1.4-.59.4-.39.6-.86.6-1.41 0-.55-.2-1.02-.6-1.41a1.93 1.93 0 0 0-1.4-.59c-.55 0-1.04.2-1.42.59-.4.39-.58.86-.58 1.41zm5.6 0c0 .55.2 1.02.57 1.41.4.4.88.59 1.43.59.57 0 1.04-.2 1.43-.59.39-.39.57-.86.57-1.41 0-.55-.2-1.02-.57-1.41A1.93 1.93 0 0 0 17.6 10c-.55 0-1.04.2-1.43.59-.38.39-.57.86-.57 1.41z" fill="#000"></path></svg>
                                                                </button>
                                                                <ul class="dropdown-menu">
                                                                    <li>
                                                                        <router-link :to="`/posts/`+post.id+`/edit`" class="dropdown-item text-decoration-none text-black">Edit</router-link>
                                                                    </li>
                                                                    <li>
                                                                        <p class="dropdown-item mb-0 text-danger text-decoration-none" @click.prevent="destroy(post.id)">Destroy</p>
                                                                    </li>
                                                                </ul>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- <p class="mt-4">paginate @posts</p>                       -->
                            </div>
                    </div>
                </div>
            </div>
        </section>
        <!--Profile Modal -->
        <div class="modal fade" id="profileModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="image.png"  aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body ps-5">
                    <div class="d-flex justify-content-between align-items-center pt-3 mb-5">
                        <h1 class="modal-title fs-4" id="image.png">Profile Information</h1>
                        <button @click.prevent="cancle" type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <form @submit.prevent="profile(user.id)" method="post">
                        <label for="" class="mb-3">Photo</label>
                        <div class="mb-4">
                            <span v-if="user.image_data == null">
                                <img src="@/assets/user.png" width="70px" height="70px" class="default-img rounded-circle me-2">
                            </span>
                            <span v-else>
                                <img :src="`${axios.defaults.baseURL}/uploads/`+JSON.parse(user.image_data).id" width="70px" height="70px" class="default-img rounded-circle me-2">
                            </span>
                            <img src="" alt="" width="70px" height="70px" class="image-preview d-none rounded-circle me-3">
                            <input type="button" class="border-0 bg-transparent text-success" value="Update" id="update-image" />
                            <input type="file" ref="file" name="image" @change="onFileSelected" class="form-control d-none" id="selectedFile">
                            <a href="#" class="text-decoration-none text-danger pe-auto" @click.prevent="imageDestroy(user.id)">Remove</a>
                        </div>
                        <span class="text-danger fw-bolder" v-if="this.error.image">
                            Image <span v-text="this.error.image"/>
                        </span>
                        <div class="form-group mb-4">
                            <label for="name" class="mb-2">Name</label>
                            <input type="text" name="name" v-model="user.name" class="w-100 border-start-0 border-end-0 border-top-0 py-2 border-bottom-1" placeholder="Your Name" style="outline:none;border-color:#ced4da">
                            <span class="text-danger fw-bolder" v-if="this.error.name">
                                Name <span v-text="this.error.name"/>
                            </span>
                        </div>
                        <div class="form-group mb-4">
                            <label for="email" class="mb-2">Email</label>
                            <input type="text" name="email" disabled="disabled" v-model="user.email" class="w-100 border-start-0 border-end-0 border-top-0 py-2 border-bottom-1" placeholder="Your Email" style="outline:none;border-color:#ced4da">
                        </div>
                        <div class="form-group mb-4">
                            <label for="bio" class="mb-2">Bio</label>
                            <textarea name="bio" id="bio" v-model="user.bio" class="w-100 border-start-0 border-end-0 border-top-0 py-2 border-bottom-1" rows="2" placeholder="Your Bio"  style="outline:none;border-color:#ced4da"></textarea>
                            <span class="text-danger fw-bolder" v-if="this.error.bio">
                                Bio <span v-text="this.error.bio"/>
                            </span>
                        </div>
                        <div class="d-flex justify-content-end">
                            <a href="" @click.prevent="cancle" class="d-inline-block" data-bs-dismiss="modal" aria-label="Close"><span class="rounded-pill bg-white border border-success text-success d-inline-block me-3 px-4 py-2">Cancel</span></a>
                            <button class="rounded-pill bg-success text-white d-inline-block border-0 px-4 py-2">Save</button>
                        </div> 
                    </form> 
                </div>
            </div>
            </div>
        </div>
        <!--Pssword Modal -->
        <div class="modal fade" id="passwordModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="image.png" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-body ps-5">
                        <div class="d-flex justify-content-between align-items-center pt-3 mb-5">
                            <h1 class="modal-title fs-4" id="image.png">Change Password</h1>
                            <button @click.prevent="canclePassword" type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form @submit.prevent="changePassword(user.id)" method="patch">
                            <div class="form-group mb-4">
                                <label for="current_password">Old Password</label>
                                <input type="password" id="currentPassword" v-model="form.old_password" name="current_password" placeholder="Old Password" class="w-100 border-start-0 border-end-0 border-top-0 py-2 border-bottom-1" style="outline:none;border-color:#ced4da">
                                <span class="text-danger fw-bolder" v-if="this.error.old_password">
                                    <span v-text="this.error.old_password"/>
                                </span>
                            </div>
                            <div class="form-group mb-4">
                                <label for="password">New Password</label>
                                <input type="password" v-model="form.password" name="password" placeholder="New Password" class="w-100 border-start-0 border-end-0 border-top-0 py-2 border-bottom-1" style="outline:none;border-color:#ced4da">
                                <span class="text-danger fw-bolder" v-if="this.error.password">
                                    Pssword <span v-text="this.error.password"/>
                                </span>
                            </div>
                            <div class="form-group mb-4">
                                <label for="password_confirmation">Confirm Password</label>
                                <input type="password" v-model="form.password_confirmation" name="password_confirmation" placeholder="Confirm Password" class="w-100 border-start-0 border-end-0 border-top-0 py-2 border-bottom-1" style="outline:none;border-color:#ced4da">
                                <span class="text-danger fw-bolder" v-if="this.error.password_confirmation">
                                    Password Confirmation <span v-text="this.error.password_confirmation"/>
                                </span>
                            </div>
                            <div class="d-flex justify-content-end">
                                <a href="" @click.prevent="canclePassword" class="d-inline-block" data-bs-dismiss="modal" aria-label="Close"><span class="rounded-pill bg-white border border-success text-success d-inline-block me-3 px-4 py-2">Cancel</span></a>
                                <button class="passSave custom rounded-pill bg-success text-white d-inline-block border-0 px-4 py-2" id="passSave">Save</button>
                            </div> 
                        </form> 
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import LoginNav from '../../components/Common/LoginNav.vue'
import NavBar from '../../components/Common/NavBar.vue';
import $ from "jquery"
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
    components: {
        LoginNav,
        NavBar
    },
        data(){
            return{
                user: '',
                users: '',
                posts: '',
                count: '',
                categories: '',
                flag: false,
                form:{
                    old_password: '',
                    password: '',
                    password_confirmation: ''
                },
                error: {
                    image: '',
                    bio: '',
                    name: '',
                    old_password: '',
                    password: '',
                    password_confirmation: ''
                },
                token: localStorage.getItem("token"),
                currentUserId: localStorage.getItem("current_user_id"),
                currentUserName:localStorage.getItem("current_user_name"),
                currentUserRole: localStorage.getItem("current_user_role"),
            }
        },
        created(){
            this.view();
        },
        methods: {
            view(){
                this.axios.get(`users/${this.$route.params.id}`,{ headers: { Authorization: this.token } })
                .then(response => {
                    this.user = response.data.user;
                    this.posts = response.data.posts;
                    this.count = response.data.count;
                    this.users = response.data.users;
                    this.categories = response.data.categories;
                })
            },
            getUser(post){
                const postUsreValues = this.users.filter(user => user.id === post.user_id)
                let user

                postUsreValues.forEach(function (element) {
                    user = element
                })

                return user
            },
            getCategory(post){
                const postCategoryValues = this.categories.filter(category => category.id === post.category_id)
                let category

                postCategoryValues.forEach(function (element) {
                category = element
                })

                return category
            },
            destroy(id) {
                Swal.fire({
                    title: "Are you sure?",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#3085d6",
                    cancelButtonColor: "#d33",
                    confirmButtonText: "Delete!",
                }).then((result) => {
                    if (result.isConfirmed) {
                    this.axios.delete(`posts/${id}`,{ headers: { Authorization: this.token } }).then(() => {
                        this.view();
                        Toast.fire({
                        icon: 'success',
                        title: 'Post Deleted successfully!'
                        });
                    });
                    }
                });
            },
            onFileSelected(event) {
                this.user.image_data = event.target.files[0];
                this.flag = true
            },
            profile(id){
                const form = new FormData()
                form.append('name',this.user.name)
                form.append('email',this.user.email)
                form.append('bio',this.user.bio)
                if(this.flag == true){
                    form.append('image',this.user.image_data)
                }
                this.axios.post(`/users/${id}`, form ,{ headers: { Authorization: this.token } })
                .then(response => {
                    $("#profileModal").hide();
                    $('.modal-backdrop').remove();
                    $('body').removeClass( "modal-open" );
                    this.view()
                    localStorage.setItem("current_user_image",response.data.image_data)
                    Toast.fire({
                        icon: 'success',
                        title: 'User Updated successfully!'
                    });  
                })
                .catch(error => {
                    this.view();
                    this.flag = false;
                    error.response.data.name ? this.error.name = error.response.data.name[0] : this.error.name='';
                    error.response.data.image ? this.error.image = error.response.data.image[0] : this.error.image='';
                    error.response.data.bio ? this.error.bio = error.response.data.bio[0] : this.error.bio='';
                })
            },
            cancle(){
                this.error.name = "";
                this.error.bio = "";
                this.error.image = "";
                this.flag = false;
                $('.default-img').removeClass('d-none');
                $('.image-preview').addClass('d-none');
                this.view();
            },
            canclePassword(){
                this.form.old_password = ''
                this.form.password = ''
                this.form.password_confirmation = ''
                this.error.old_password = ''
                this.error.password = ''
                this.error.password_confirmation = ''
                this.view();
            },
            imageDestroy(id){
                Swal.fire({
                    title: "Are you sure?",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#3085d6",
                    cancelButtonColor: "#d33",
                    confirmButtonText: "Delete!",
                }).then((result) => {
                    if (result.isConfirmed) {
                    this.axios.delete(`user/${id}/image`,{headers: {Authorization: this.token}})
                    .then(() => {
                        $("#profileModal").hide();
                        $('.modal-backdrop').remove();
                        localStorage.removeItem("current_user_image")
                        $('body').removeClass( "modal-open" );
                        this.flag = false;
                        this.user.image_data = "";
                        this.view()
                        Toast.fire({
                            icon: 'success',
                            title: 'User Image Deleted successfully!'
                        });
                    });
                    }
                });
            },
            changePassword(id){
                this.axios.patch(`/user/${id}/password`,this.form,{headers: {Authorization: this.token}})
                .then(() => {
                    $("#passwordModal").hide();
                    $('.modal-backdrop').remove();
                    $('body').removeClass( "modal-open" );
                    Toast.fire({
                        icon: 'success',
                        title: 'Password Change successfully!'
                    }); 
                })
                .catch(error => {
                    error.response.data.error ? this.error.old_password = error.response.data.error : this.error.old_password =''
                    error.response.data.password ? this.error.password = error.response.data.password[0] : this.error.password =''
                    error.response.data.password_confirmation ? this.error.password_confirmation = error.response.data.password_confirmation[0] : this.error.password_confirmation =''
                })
            }
        }
    }
    $(document).ready(function(){
        $('#update-image').click(function() {
            $("#selectedFile").click();
        });
        $('#selectedFile').on('change', function() {
            $('.default-img').addClass('d-none');
            if($(this).val().length > 0) {
                const fileReader = new FileReader();
                fileReader.onload = function (data) {
                $('.image-preview').attr('src', data.target.result);
                }
                fileReader.readAsDataURL($(this).prop('files')[0]);
                $('.image-preview').removeClass('d-none');
                $('.default-img').addClass('d-none');
            }
        });

        $('.passSave').prop('disabled', true);
        $('#currentPassword').keyup(function () {
            if ($(this).val() != '') {
                $('.passSave').prop('disabled', false);
                $('.passSave').removeClass('custom');
            }
        });

    });
</script>

<style>
    .custom{
        opacity: 0.9 !important;
        cursor: not-allowed;
    }
</style>