<template>
    <div id="app">
        <login-nav />
        <div class="container" style="margin-top:72px">
            <div class="row py-5">
                <div class="col-12">
                    <a href="/register" class="btn btn-primary mb-3">Create</a>
                    <table class="table table-striped">
                        <thead>
                          <tr>
                            <th scope="col">#</th>
                            <th scope="col">Name</th>
                            <th scope="col">Image</th>
                            <th scope="col">Email</th>
                            <th scope="col">Bio</th>
                            <th scope="col">Role</th>
                            <th scope="col">Action</th>
                          </tr>
                        </thead>
                        <tbody>
                          <tr class="align-middle" v-for="user in users" :key="user.id">
                            <th scope="row">{{ user.id }}</th>
                            <td class="align-middle">{{ user.name }}</td>
                            <td>
                                <span v-if="user.image_data == null">
                                    <img src="@/assets/user.png" width="50px" height="50px" class="rounded-circle me-2">
                                </span>
                                <span v-else>
                                    <img :src="`${axios.defaults.baseURL}/uploads/`+JSON.parse(user.image_data).id" width="50px" height="50px" class="rounded-circle me-2">
                                </span>
                            </td>
                            <td>{{ user.email }}</td>
                            <td>{{ user.bio }}</td>
                            <td>{{ user.role }}</td>
                            <td>
                                <button class="btn btn-success me-2" @click="getUser(user.id)" :data-id="user.id" data-bs-toggle="modal" data-bs-target="#editModal">Edit</button>
                                <button class="btn btn-danger" @click.prevent="destroy(user.id)">Delete</button>
                            </td>
                          </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <!-- user edit model -->
        <div class="modal fade" id="editModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="image.png" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-body px-3">
                        <div class="d-flex justify-content-between align-items-center pt-3 mb-3">
                            <h1 class="modal-title fs-4" id="image.png">Edit User</h1>
                            <button @click.prevent="cancle" type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form @submit.prevent="update(form.id)" method="patch">
                            <label for="" class="mb-3">Photo</label>
                            <div class="mb-4">
                                <span v-if="form.image_data == null">
                                    <img src="@/assets/user.png" width="70px" height="70px" class="default-img rounded-circle me-2">
                                </span>
                                <span v-else>
                                    <img :src="`${axios.defaults.baseURL}/uploads/`+JSON.parse(form.image_data).id" width="70px" height="70px" class="default-img rounded-circle me-2">
                                </span>
                                <img src="" alt="" width="70px" height="70px" class="image-preview d-none rounded-circle me-3">
                                <input type="button" class="border-0 bg-transparent text-success" value="Update" id="update-image" />
                                <input type="file" ref="file" name="image" @change="onFileSelected" class="form-control d-none" id="selectedFile">
                                <a href="#" class="text-decoration-none text-danger pe-auto" @click.prevent="imageDestroy(form.id)">Remove</a>
                            </div>
                            <span class="text-danger fw-bolder" v-if="this.error.image">
                                Image <span v-text="this.error.image"/>
                            </span>
                            <div class="from-group mb-4">
                                <label for="name" class="mb-2">Name</label>
                                <input type="text" name="name" v-model="form.name" placeholder="Your Name" class="form-control">
                                <span class="text-danger fw-bolder" v-if="this.error.name">
                                    Name <span v-text="this.error.name"/>
                                </span>
                            </div>
                            <div class="form-group mb-4">
                                <label for="email" class="mb-2">Email</label>
                                <input type="text" name="email" v-model="form.email" placeholder="Your Email(example@gmail.com)" class="form-control">
                                <span class="text-danger fw-bolder" v-if="this.error.email">
                                    Email <span v-text="this.error.email"/>
                                </span>
                            </div>
                            <div class="form-group mb-4">
                                <label for="role" class="mb-2">Role</label>
                                <select id="role" v-model="form.role" class="form-select">
                                    <option value="" selected disabled>Select Role</option>
                                    <option value="admin">Admin</option>
                                    <option value="user">User</option>
                                </select>
                                <span class="text-danger fw-bolder" v-if="this.error.role">
                                    Role <span v-text="this.error.role"/>
                                </span>
                            </div>
                            <div class="from-group mb-4">
                                <label for="bio" class="mb-2">Bio</label>
                                <textarea name="bio" id="" v-model="form.bio" class="form-control w-100" rows="3" placeholder="Your Bio"></textarea>
                                <span class="text-danger fw-bolder" v-if="this.error.bio">
                                    Bio <span v-text="this.error.bio"/>
                                </span>
                            </div>
                            <div class="d-flex justify-content-end">
                                <a href="" @click.prevent="cancle" class="d-inline-block me-2" data-bs-dismiss="modal" aria-label="Close"><span class="btn btn-outline-success">Cancel</span></a>
                                <button class="btn btn-secondary">Update</button>
                            </div> 
                        </form> 
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import LoginNav from '@/components/Common/LoginNav'
import $ from "jquery"
import Swal from "sweetalert2"
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
    },
    data(){
        return {
            users: '',
            user: '',
            flag: false,
            token: localStorage.getItem("token"),
            currentUserRole: localStorage.getItem("current_user_role"),
            form: {
                name: this.name,
                email: this.email,
                role: this.role,
                bio: this.bio,
            },
            error: {
                name: "", 
                email: "",
                role: "",
                bio: "",
            },
        }
    },
    created(){
        if(this.currentUserRole != 'admin'){
            this.$router.push({name: 'home'});
        }
        this.view();
    },
    methods:{
        view(){
            this.axios.get('/users', {headers: {Authorization: this.token}})
            .then(response => this.users = response.data)
        },
        destroy(id){
            Swal.fire({
                    title: "Are you sure?",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#3085d6",
                    cancelButtonColor: "#d33",
                    confirmButtonText: "Delete!",
                }).then((result) => {
                    if (result.isConfirmed) {
                        this.axios.delete(`/users/${id}`,{ headers: { Authorization: this.token } })
                        .then(() => {
                            this.view();
                            Toast.fire({
                            icon: 'success',
                            title: 'User Deleted successfully!'
                            });
                        })
                    }
                });
            
        },
        getUser(id){
            this.axios.get(`/users/${id}`, { headers: { Authorization: this.token } } )
            .then(response => {
                this.form = response.data.user
            })
        },
        onFileSelected(event) {
            this.form.image_data = event.target.files[0];
            this.flag = true
        },
        update(id){
            const form = new FormData()
            form.append('name',this.form.name)
            form.append('email',this.form.email)
            form.append('bio',this.form.bio)
            form.append('role',this.form.role)
            if(this.flag == true){
                form.append('image',this.form.image_data)
            }
            this.axios.post(`/users/${id}`, form, { headers: { Authorization: this.token } } )
            .then(() => {
                $("#editModal").hide();
                $('.modal-backdrop').remove();
                $('body').removeClass( "modal-open" );
                this.view();
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
                error.response.data.email ? this.error.email = error.response.data.email[0] : this.error.email='';
                error.response.data.role ? this.error.role = error.response.data.role[0] : this.error.role='';
            })
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
                    $("#editModal").hide();
                    $('.modal-backdrop').remove();
                    localStorage.removeItem("current_user_image")
                    $('body').removeClass( "modal-open" );
                    this.flag = false;
                    this.form.image_data = "";
                    this.view();
                    Toast.fire({
                        icon: 'success',
                        title: 'User Image Deleted successfully!'
                    });
                });
                }
            });
        },
        cancle(){
            this.error.name = "";
            this.error.bio = "";
            this.error.image = "";
            this.error.email = "";
            this.error.role = "";
            this.flag = false;
            $('.default-img').removeClass('d-none');
            $('.image-preview').addClass('d-none');
            this.view();
        }
    }
}

</script>
