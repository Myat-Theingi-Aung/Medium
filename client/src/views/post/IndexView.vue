<template>
    <div id="app">
        <div v-if="currentUser">
            <login-nav @search="searchResult" />
            <section class="container" style="margin-top: 75px;">
            <div class="row">
                <div class="blk col-12 col-lg-8 border-end border-dark-50">
                    <div class="pt-5 postList" id="postList">
                        <div v-for="post in postsList" :key="post.id">
                            <div class="pb-5">
                                <div class="row">
                                    <div class="col-12">
                                        <div class="d-flex align-items-center mb-3">
                                            <router-link :to="`/profile/`+post.user_id">
                                                <span v-if="getUser(post).image_data">
                                                    <img :src="`${axios.defaults.baseURL}/uploads/`+JSON.parse(getUser(post).image_data).id" alt="" class="rounded-circle me-2" width="30px" height="30px">
                                                </span>
                                                <span v-else>
                                                    <img src="@/assets/user.png" alt="" class="rounded-circle me-2" width="30px" height="30px">
                                                </span>
                                            </router-link>
                                            <router-link :to="`/profile/`+post.user_id" class="text-decoration-none text-black">
                                                <p class="m-0"><span class="fs-6 me-1 fw-bold">{{ getUser(post).name  }}</span><span class="me-1">.</span><span class="text-black-50">{{ post.created_at | moment("from", "now", true) }} ago</span></p>
                                            </router-link>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-8">
                                        <router-link :to="`/posts/`+post.id" class="text-decoration-none text-black">
                                            <h4 class="fw-bolder">{{ post.title }}</h4>
                                        </router-link>
                                        <router-link :to="`/posts/`+post.id" class="text-decoration-none" style="color: rgba(41, 41, 41, 1)">
                                            <p class="m-0 d-none d-md-block" style="line-height:1.7;text-align:justify;">
                                                {{ post.description | truncate(150) }}
                                            </p>
                                        </router-link>         
                                    </div>
                                    <div class="col-1"></div>
                                    <div class="col-3">
                                        <img :src="`${axios.defaults.baseURL}/uploads/`+JSON.parse(post.image_data).id" class="img-fluid mb-4" width="110px" height="110px">
                                    </div> 
                                </div>
                                    <div class="row mt-4">
                                        <div class="col-12 col-md-9">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div class="align-items-end" style="color:rgba(117, 117, 117, 1);">
                                                    <router-link :to="`/category/`+getCategory(post)" class="rounded-pill text-capitalize text-decoration-none d-inline-block px-3 pb-1" style="background-color: rgba(242, 242, 242, 1);color:rgba(117, 117, 117, 1);">{{ getCategory(post) }}</router-link>
                                                    <span class="mx-1">.</span> <span>9 min read</span> <span class="mx-1">.</span> <span class="d-none d-md-inline-block">Selected for you</span>
                                                </div>
                                                <div v-if="post.user_id == currentUserId">
                                                    <div class="dropdown">
                                                        <button class="btn btn-white p-0 border-0" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none"><path fill-rule="evenodd" clip-rule="evenodd" d="M4.39 12c0 .55.2 1.02.59 1.41.39.4.86.59 1.4.59.56 0 1.03-.2 1.42-.59.4-.39.59-.86.59-1.41 0-.55-.2-1.02-.6-1.41A1.93 1.93 0 0 0 6.4 10c-.55 0-1.02.2-1.41.59-.4.39-.6.86-.6 1.41zM10 12c0 .55.2 1.02.58 1.41.4.4.87.59 1.42.59.54 0 1.02-.2 1.4-.59.4-.39.6-.86.6-1.41 0-.55-.2-1.02-.6-1.41a1.93 1.93 0 0 0-1.4-.59c-.55 0-1.04.2-1.42.59-.4.39-.58.86-.58 1.41zm5.6 0c0 .55.2 1.02.57 1.41.4.4.88.59 1.43.59.57 0 1.04-.2 1.43-.59.39-.39.57-.86.57-1.41 0-.55-.2-1.02-.57-1.41A1.93 1.93 0 0 0 17.6 10c-.55 0-1.04.2-1.43.59-.38.39-.57.86-.57 1.41z" fill="#000"></path></svg>
                                                        </button>
                                                        <ul class="dropdown-menu">
                                                            <li>
                                                                <router-link :to="`/posts/${post.id}/edit`" class="dropdown-item text-decoration-none text-black">Edit</router-link>
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
                    <div v-if="this.rows > this.perPage">
                        <b-pagination
                        v-model="currentPage"
                        :total-rows="rows"
                        :per-page="perPage"
                        aria-controls="postList"
                        first-number
                        last-number
                        prev-text="Prev"
                        next-text="Next"
                        ></b-pagination>
                    </div>
                </div>
                <div class="d-none d-lg-block col-4 pt-5 ps-5 position-relative" style="z-index:1">
                    <div class="sticky-top" style="top:120px">
                        <h3 class="fw-bolder mb-4">2022 in Latest Posts</h3>
                        <div class="pb-4 border-bottom border-dark-50">
                            <div v-for="latest in latestPost" :key="latest.id">
                                <div class="d-flex align-items-center mb-2">
                                    <router-link :to="`/profile/`+latest.user_id" class="text-decoration-none text-black">
                                        <span v-if="getUser(latest).image_data">
                                            <img :src="`${axios.defaults.baseURL}/uploads/`+JSON.parse(getUser(latest).image_data).id" alt="" class="rounded-circle me-2" width="30px" height="30px">
                                        </span>
                                        <span v-else>
                                            <img src="@/assets/user.png" alt="" class="rounded-circle me-2" width="30px" height="30px">
                                        </span>
                                    </router-link>
                                    <router-link :to="`/profile/`+latest.user_id" class="text-decoration-none text-black"><p class="m-0"><span class="fs-6 me-1 text-capitalize">{{ getUser(latest).name }}</span></p></router-link>
                                </div>
                                <router-link :to="`/posts/`+latest.id" class="text-decoration-none text-black">
                                    <p class="fw-bolder fs-6">{{ latest.title }}</p>
                                </router-link>
                            </div>
                        </div>
                        <div class="pt-5">
                        <span v-for="category in categories" :key="category.id">
                            <router-link :to="`/category/`+category.name" class="rounded-pill me-2 text-capitalize d-inline-block text-black text-decoration-none mb-3 px-3 py-1" style="background-color: rgba(242, 242, 242, 1);">{{ category.name }}</router-link>
                        </span>
                        </div>
                    </div>
                </div>
            </div>
            </section>
        </div>
        <div v-else>
            <nav-bar />
            <section class="blk container-fluid border-bottom border-dark" style="background-color:#FFC017;margin-top:75px;">
                <div class="row py-5">
                    <div class="col-12 pb-5">
                    <div class="container">
                        <div class="row">
                        <div class="col-lg-7 col-12">
                            <h1 class="mt-3 mb-4 title">Stay curious.</h1>
                            <p class="fs-4 w-lg-75 mb-5 pe-5">Discover stories, thinking, and expertise from writers on any topic.</p>
                            <a class="rounded-pill fs-5 text-bg-dark d-inline-block px-5 py-2 text-decoration-none" href="#">Start Reading</a>
                        </div>
                        </div>
                    </div>
                    </div>
                </div>
            </section>
            <section class="container pt-5">
                <div class="row flex-row-reverse">
                    <div class="col-lg-4 col-12" style="z-index: 1;">
                        <div style="position:sticky;top:127px">
                            <category-side :categories="categories" />
                        </div>
                    </div>
                    <hr class="d-lg-none mb-5">
                    <div class="col-lg-1"></div>
                    <div class="col-lg-7 col-12">
                        <div v-for="post in posts" :key="post.id">
                            <div class="mb-5">
                                <div class="row">
                                    <div class="col-8">
                                        <div class="d-flex justify-content-start align-items-center mb-0 mb-md-2">
                                            <router-link :to="`/profile/`+post.user_id">
                                                <span v-if="getUser(post).image_data">
                                                    <img :src="`${axios.defaults.baseURL}/uploads/`+JSON.parse(getUser(post).image_data).id" alt="" class="rounded-circle" width="30px" height="30px">
                                                </span>
                                                <span v-else>
                                                    <img src="@/assets/user.png" alt="" class="rounded-circle" width="30px" height="30px">
                                                </span>
                                            </router-link>
                                            <router-link :to="`/profile/`+post.user_id" class="text-decoration-none text-black">
                                                <p class="fw-bold px-2 m-0">{{ getUser(post).name }}</p>
                                            </router-link>
                                        </div>                
                                        <router-link :to="`/posts/${post.id}`" class="text-decoration-none text-black">
                                            <h4 class="fw-bolder">{{ post.title }}</h4>
                                        </router-link>
                                        <router-link :to="`/posts/${post.id}`" class="text-decoration-none d-inline-block mb-3" style="color: rgba(41, 41, 41, 1)">
                                            <p class="m-0 d-none d-md-block" style="line-height:1.7;text-align:justify;">
                                            <span class="">{{ post.description | truncate(80) }}</span>
                                            </p>
                                        </router-link>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div class="align-items-end" style="color:rgba(117, 117, 117, 1);">
                                                <span>{{ post.created_at | moment("from", "now", true) }} ago</span> <span class="mx-1">.</span> <span>9 min read</span> <span class="mx-1">.</span> <router-link :to="`/category/`+getCategory(post)" class="d-none text-decoration-none d-md-inline-block rounded-pill d-inline-block px-3 pb-1" style="background-color: rgba(242, 242, 242, 1);color:rgba(117, 117, 117, 1);">{{ getCategory(post) }}</router-link>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-4">
                                        <img :src="`${axios.defaults.baseURL}/uploads/`+ JSON.parse(post.image_data).id" class="img-fluid mb-4" width="200px" height="200px">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>
</template>

<script>
import LoginNav from "@/components/Common/LoginNav"
import NavBar from "@/components/Common/NavBar"
import Swal from "sweetalert2"
import CategorySide from '../../components/Common/CategorySide.vue';
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
        NavBar,
        CategorySide,
    },
    data(){
        return{
            categories : '',
            photo: '',
            posts: '',
            search: '',
            currentPage: 1,
            perPage: 2,
            rows: '',
            users: '',
            latestPost: '',
            token : localStorage.getItem('token'),
            currentUser : localStorage.getItem('current_user_name'),
            currentUserId : localStorage.getItem('current_user_id'),
            get postsList() {
                return this.posts.slice(
                (this.currentPage - 1) * this.perPage,
                this.currentPage * this.perPage,
            );
            }
        }
    },
    created(){
        this.view();
        this.home();
    },
    watch:{
        search(newVal, oldVal){
            if(newVal != oldVal){
                this.view();
            }
        }
    },
    methods:{
        home(){
            this.axios.get(`/home`)
            .then(response => {
                this.posts = response.data.posts
                this.categories = response.data.categories
                this.users = response.data.users
            });
        },
        searchResult(value){
            this.search = value
        },
        view(){
            this.axios.get(`/posts?search=${this.search}`,{ headers: { Authorization: this.token } })
            .then(response => { 
                this.posts = response.data.posts;
                this.users = response.data.users;
                this.categories = response.data.categories;
                this.latestPost = response.data.latest;
                this.rows = this.posts.length;
            });
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
            category = element.name
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
                    title: 'Deleted successfully!'
                    });
                });
                }
            });
        },
    },
}
</script>