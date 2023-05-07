<template>
    <div id="app">
        <div v-if="currentUserId"><login-nav /></div>
        <div v-else><nav-bar /></div>
        <section class="container pt-5" style="margin-top:72px">
            <div class="row flex-row-reverse">
                <div class="col-lg-4 col-12 pt-lg-5" style="z-index: 1;">
                    <div class="pt-lg-5" style="position:sticky;top:135px">
                        <category-side :categories="categories" />
                    </div>
                </div>
                <hr class="d-lg-none mb-5">
                <div class="col-lg-1"></div>
                <div class="col-lg-7 col-12">
                    <div class="d-flex pb-3 align-items-center border-bottom border-dark-50">
                        <span class="px-1 pb-1 me-2 rounded-circle" style="background-color:rgb(237, 237, 237);"><svg width="21" height="21" class="uv"><path d="M4.66 8.72L3.43 9.95a1.75 1.75 0 0 0 0 2.48l5.14 5.13c.7.7 1.8.69 2.48 0l1.23-1.22 5.35-5.35a2 2 0 0 0 .51-1.36l-.32-4.29a2.42 2.42 0 0 0-2.15-2.14l-4.3-.33c-.43-.03-1.05.2-1.36.51l-.79.8-2.27 2.28-2.28 2.27zm9.83-.98a1.25 1.25 0 1 0 0-2.5 1.25 1.25 0 0 0 0 2.5z" fill-rule="evenodd"></path></svg></span>
                        <h1 class="m-0 fw-bolder text-capitalize">{{ category.name }}</h1>
                    </div>
                    <div v-for="post in posts" :key="post.id">
                        <div class="mt-5 mb-5">
                            <div class="row">
                                <div class="col-8">
                                    <div class="d-flex justify-content-start align-items-center mb-0 mb-md-2">
                                        <router-link :to="`/profile/`+post.user_id" class="text-decoration-none">
                                            <span v-if="getUser(post).image_data">
                                                <img :src="`${axios.defaults.baseURL}/uploads/`+JSON.parse(getUser(post).image_data).id" height="24px" width="24px" class="rounded-circle me-2">
                                            </span>
                                            <span v-else>
                                                <img src="@/assets/user.png" height="24px" width="24px" class="rounded-circle me-2">
                                            </span>
                                        </router-link>
                                        <router-link :to="`/profile/`+post.user_id" class="text-decoration-none text-black">
                                            <p class="fw-bold px-2 m-0"> {{ getUser(post).name }} </p>
                                        </router-link>                 
                                    </div>
                                    <router-link :to="`/posts/`+post.id" class="text-decoration-none text-black">
                                        <p class="fw-bold fs-5 fs-md-3"> {{ post.title }}</p>
                                    </router-link>
                                    <router-link :to="`/posts/`+post.id" class="text-decoration-none" style="color: rgba(41, 41, 41, 1)">
                                        <p class="fs-6 d-none d-md-block" style="color:rgba(117, 117, 117, 1);font-weight:500;"> {{ post.description }}</p>
                                    </router-link>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="align-items-end" style="color:rgba(117, 117, 117, 1);">
                                            <span> {{ post.created_at | moment("from", "now", true) }} ago</span> <span class="mx-1">.</span> <span>9 min read</span> <span class="mx-1">.</span> <router-link :to="`/category/`+getCategory(post).name" class="d-none text-capitalize text-decoration-none d-md-inline-block rounded-pill d-inline-block px-3 pb-1" style="background-color: rgba(242, 242, 242, 1);color:rgba(117, 117, 117, 1);">{{ getCategory(post).name }}</router-link>
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
                                <div class="col-4">
                                    <img :src="`${axios.defaults.baseURL}/uploads/`+ JSON.parse(post.image_data).id" class="img-fluid mb-4" width="110px" height="110px">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
</template>

<script>
import LoginNav from "@/components/Common/LoginNav"
import NavBar from '../../components/Common/NavBar.vue'
import CategorySide from '../../components/Common/CategorySide.vue'

export default {
  components: {
    LoginNav,
    NavBar,
    CategorySide
  },
  
    data(){
    return{
      categories: '',
      category: '',
      users: '',
      posts: '',
      token: localStorage.getItem("token"),
      currentUserId: localStorage.getItem('current_user_id')
    }
  },
  created(){
    this.view()
  },
  watch: {
        $route(){
            this.view();
        }
    },
  methods: {
    view(){
        this.axios.get(`category/${this.$route.params.name}`,{ headers: { Authorization : this.token } })
        .then(response => {
            this.users = response.data.users;
            this.categories = response.data.categories;
            this.category = response.data.category;
            this.posts = response.data.posts;
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
        category = element
        })

        return category
    },
  },
}
</script>