<template>
    <div id="app">
        <login-nav />
        <section class="container" style="margin-top: 72px">
            <div class="row py-5">
                <div class="col-12 col-lg-8 mx-auto">
                    <div class="px-3 py-2 px-md-5 py-md-4 border border-3 border-secondary" style="border-radius:20px">
                        <h3 class="mb-3">Post Edit</h3>
                        <form @submit.prevent="update" method="post" enctype="multipart/form-data">
                            <div class="form-group mb-4">
                                <input
                                  type="text"
                                  class="form-control"
                                  name="title"
                                  v-model="post.title"
                                  id="file1"
                                  placeholder="Post Title"
                                />
                                <span class="text-danger fw-bolder" v-if="this.error.title">
                                    Title <span v-text="this.error.title"/>
                                </span>
                            </div>
                            <div class="form-group mb-4">
                                <select class="form-select" v-model="post.category_id" aria-label="Default select example">
                                    <option value="" selected>Select Category</option>
                                    <option v-for="category in categories" :key="category.id" :value="category.id">{{ category.name }}</option>
                                </select>
                                <span class="text-danger fw-bolder" v-if="this.error.category_id">
                                    Category <span v-text="this.error.category_id"/>
                                </span>
                            </div>
                            <div class="from-group mb-4">
                                <img src="" alt="" class="image-preview d-none mb-4 img-fluid rounded" style="width:100px;height:100px">
                                <img :src="`${axios.defaults.baseURL}/uploads/`+ this.photo" alt="" class="db-img rounded img-fluid mb-4" width="100px" height="100px">
                                <input class="form-control" type="file" ref="file" id="file" name="image" @change="onFileSelected">
                                <span class="text-danger fw-bolder" v-if="this.error.image">
                                    Image <span v-text="this.error.image"/>
                                </span>
                            </div>
                            <div class="form-group mb-4">
                                <textarea v-model="post.description" name="bio" id="bio" placeholder="Your Description" class="w-100 form-control" rows="3"></textarea>
                                <span class="text-danger fw-bolder" v-if="this.error.description">
                                    Description <span v-text="this.error.description"/>
                                </span>
                            </div>
                            <button class="btn btn-secondary">Publish</button>
                        </form>
                    </div>
                </div>
            </div>
        </section>
    </div>
</template>

<script>
import LoginNav from '@/components/Common/LoginNav'
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
    },

    data(){
        return{
            photo: '',
            post: '',
            categories: '',
            flag: false,
            token: localStorage.getItem("token"),
            currentUserId : localStorage.getItem('current_user_id'),
            error: {
                title: '',
                description: '',
                image: '',               
                user_id: '',
                category_id: '',
            }
        }
    },
    created(){
        if(this.token == null){
            this.$router.push({name: 'home'});
        }
        this.view();
    },
    watch :{
        flag(a,b){
            if(a != b){
                this.$router.push({name: 'home'});
            }
        }
    },
    methods:{
        view(){
            this.axios.get(`posts/${this.$route.params.id}`,{ headers: { Authorization: this.token } })
            .then(response => {
                this.post = response.data.post
                this.photo = JSON.parse(this.post.image_data).id
                if(this.post.user_id != this.currentUserId){
                    this.flag = true
                }
            })

            this.axios.get(`categories`,{ headers: { Authorization: this.token } })
            .then(response => this.categories = response.data ); 
        },
        onFileSelected(event) {
            this.post.image_data = event.target.files[0];
        },
        update(){
            const form = new FormData()
            form.append('title',this.post.title)
            form.append('user_id',this.currentUserId)
            form.append('category_id',this.post.category_id)
            form.append('image',this.post.image_data)
            form.append('description',this.post.description)
            this.axios.put(`/posts/${this.$route.params.id}`, form ,{ headers: { Authorization: this.token } })
            .then(() => {
                Toast.fire({
                    icon: 'success',
                    title: 'Post Updated successfully!'
                });
                this.$router.push({name: 'home'});
            })
            .catch(error => {
                error.response.data.category_id ? this.error.category_id = error.response.data.category_id[0] : this.error.category_id='';
                error.response.data.title ? this.error.title = error.response.data.title[0] : this.error.title='';
                error.response.data.image ? this.error.image = error.response.data.image[0] : this.error.image='';
                error.response.data.description ? this.error.description = error.response.data.description[0] : this.error.description='';
            })
        },
    }
}

$(document).ready(function(){
    $('#file').on('change', function() {
        if($(this).val().length > 0) {
            const fileReader = new FileReader();
            fileReader.onload = function (data) {
            $('.image-preview').attr('src', data.target.result);
            }
            fileReader.readAsDataURL($(this).prop('files')[0]);
            $('.image-preview').removeClass('d-none');
            $('.db-img').addClass('d-none');
        }
    });
})

</script>

<style></style>