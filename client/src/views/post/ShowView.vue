<template>
    <div id="app">
        <div v-if="currentUserId">
            <login-nav />
        </div>
        <div v-else>
            <nav-bar />
        </div>
        <section class="container" style="margin-top:72px">
            <div class="row border-bottom">
                <div class="blk col-12 col-lg-8 border mb-5 border-top-0 border-start-0 border-bottom-0 pt-5 pe-3">
                    <div class="d-flex mb-3 me-md-4 justify-content-between align-items-center">
                        <div class="d-flex">
                            <router-link :to="`/profile/`+post.user_id">
                                <span v-if="getUser(post).image_data">
                                    <img :src="`${axios.defaults.baseURL}/uploads/`+JSON.parse(getUser(post).image_data).id" width="40px" height="40px" class="rounded-circle me-2">
                                </span>
                                <span v-else>
                                    <img src="@/assets/user.png" width="40px" height="40px" class="rounded-circle me-2">
                                </span>
                            </router-link>
                            <div class="ms-md-3">
                                <router-link :to="`/profile/`+post.user_id" class="text-decoration-none text-black"><p class="mb-0 text-capitalize fw-bold">{{ getUser(post).name }}</p></router-link>
                                <router-link :to="`/profile/`+post.user_id" class="text-decoration-none text-black"><span class="txt-color">{{ post.created_at | moment("from", "now", true) }} ago</span></router-link>
                            </div>          
                        </div>
                        <span v-if="currentUserId">
                            <span v-if="currentUserId == post.user_id">
                                <div class="me-md-4 d-flex">
                                    <router-link :to="`/posts/`+post.id+`/edit`" class="badge px-3 py-2 text-decoration-none text-white rounded-pill bg-success">Edit</router-link>
                                    <span class="badge rounded-pill bg-danger px-3 ms-2 py-2">
                                        <p class="mb-0 text-white text-decoration-none" @click.prevent="destroy(post.id)">Destroy</p>
                                    </span>
                                </div>
                            </span>
                        </span>
                    </div>
                    <img :src="`${axios.defaults.baseURL}/uploads/`+this.photo" class="img-fluid mb-4" width="100%" height="300px">
                    <p class="fs-3 fw-bold mb-4">{{ post.title }}</p>
                    <p class="lh-lg" style="text-align: justify;">
                        {{ post.description }}
                    </p>
                </div>
                <div class="col-4 d-none d-lg-block py-5 position-relative">
                    <div class="py-5 sidebar px-4">
                        <span v-if="getUser(post).image_data">
                            <img :src="`${axios.defaults.baseURL}/uploads/`+JSON.parse(getUser(post).image_data).id" width="70px" height="70px" class="rounded-circle me-2">
                        </span>
                        <span v-else>
                            <img src="@/assets/user.png" width="70px" height="70px" class="rounded-circle me-2">
                        </span>
                        <p class="fs-5 fw-bold m-0 text-capitalize pb-2">{{ getUser(post).name }}</p>
                        <p class="txt-color fw-bold">{{ count }} Posts</p>
                        <p class="txt-color">{{ getUser(post).bio }}</p>
                        <div>
                            <p class="fs-5" style="font-weight:500;">More from Medium</p>
                            <div>
                                <div v-for="latest in latestPost" :key="latest.id"> 
                                    <div class="row mb-3">
                                        <div class="col-9">
                                            <div class="d-flex align-items-center mb-2">
                                                <router-link :to="`/profile/`+latest.user_id" class="text-decoration-none text-black">
                                                    <span v-if="getUser(latest).image_data">
                                                        <img :src="`${axios.defaults.baseURL}/uploads/`+JSON.parse(getUser(latest).image_data).id" width="20px" height="20px" class="rounded-circle me-2">
                                                    </span>
                                                    <span v-else>
                                                        <img src="@/assets/user.png" width="20px" height="20px" class="rounded-circle me-2">
                                                    </span>
                                                </router-link>
                                                <router-link :to="`/profile/`+latest.user_id" class="text-decoration-none text-black">
                                                    <p class="mb-0 text-capitalize">{{ getUser(latest).name }}</p>
                                                </router-link>
                                            </div>
                                            <router-link :to="`/posts/${latest.id}`" class="text-decoration-none text-black">
                                                <p class="fw-bold fs-6" style="letter-spacing:1px;">{{latest.title}}</p>
                                            </router-link>
                                        </div>
                                        <div class="col-3 d-flex justify-content-end">
                                            <img :src="`${axios.defaults.baseURL}/uploads/`+ JSON.parse(latest.image_data).id" alt="" width="56px" height="56px">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <!-- comment -->
        <section class="container">
            <div class="row pt-4">
                <div class="col-12">
                    <p><span class="fw-bold">Comment</span> <span class="badge ms-3 rounded-pill bg-secondary">{{ count }}</span></p>
                    <div class="mx-md-5">
                        <div v-if="currentUserId">
                            <form @submit.prevent="store" method="post">
                                <div class="form-floating">
                                    <textarea class="form-control comment-input" v-model="form.comment" placeholder="What are you thoughts" id="floatingTextarea2" style="height: 100px"></textarea>
                                    <label for="floatingTextarea2">Here you can left message!</label>
                                </div>
                                <span class="text-danger fw-bolder" v-if="this.error.comment">
                                    Comment <span v-text="this.error.comment"/>
                                </span>
                                <div class="d-flex justify-content-end mt-3">
                                    <button class="btn btn-secondary comment">Comment</button>
                                </div>
                            </form>
                        </div>
                        <div class="mt-4">
                            <div v-for="comment in comments" :key="comment.id">
                                <div class="mb-5">
                                    <div class="d-flex mb-2">
                                        <router-link :to="`/profile/`+comment.user_id" class="text-decoration-none text-black">
                                            <span v-if="getUser(comment).image_data">
                                                <img :src="`${axios.defaults.baseURL}/uploads/`+JSON.parse(getUser(comment).image_data).id" height="50px" width="50px" class="rounded-circle me-2">
                                            </span>
                                            <span v-else>
                                                <img src="@/assets/user.png" height="50px" width="50px" class="rounded-circle me-2">
                                            </span>
                                        </router-link>
                                        <div class="ms-3">
                                            <router-link :to="`/profile/`+comment.user_id" class="text-decoration-none text-black"><p class="mb-0 fw-bold text-capitalize">{{ getUser(comment).name }}</p></router-link>
                                            <router-link :to="`/profile/`+comment.user_id" class="text-decoration-none text-black"><span class="txt-color">{{ comment.created_at | moment("from","now",true) }} ago</span></router-link>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-12">
                                            <p style="font-weight:500;background-color:#e4e5e7;" class="p-2 rounded">{{ comment.comment }}</p>
                                        </div> 
                                        <div class="col-12 justify-content-end" v-if="currentUserId">
                                            <div class="d-flex justify-content-end align-items-center">
                                                <button @click.prevent="showReplyForm(comment.id)" :id="`reply-`+comment.id" class="btn btn-secondary me-2">Reply</button>
                                                <span v-if="currentUserId == comment.user_id">
                                                    <button @click.prevent="showEditForm(comment.id)" :id="`edit-`+comment.id" class="edit-btn-id btn btn-warning me-2">Edit</button>
                                                    <button @click.prevent="commentDestroy(comment.id)" class="btn btn-danger" data-method="delete" data-confirm="Are you sure">Delete</button>
                                                </span>
                                            </div>
                                        </div>                            
                                    </div>
                                    <div :class="`mt-4 d-none reply-form reply-form-`+comment.id">
                                        <form @submit.prevent="reply(comment.id)" method="post">
                                            <div class="form-floating">
                                                <textarea class="form-control" v-model="form.reply_commet" placeholder="What are you thoughts" id="floatingTextarea2" style="height: 100px"></textarea>
                                                <label for="floatingTextarea2">Your suggest comments?</label>
                                            </div>
                                            <span class="text-danger fw-bolder" v-if="error.reply">
                                                Comment <span v-text="error.reply"/>
                                            </span>
                                            <div class="d-flex justify-content-end mt-3">
                                                <button class="btn btn-secondary">Comment</button>
                                            </div>
                                        </form>
                                    </div>
                                    
                                    <div :class="`mt-4 d-none edit-form edit-form-`+comment.id">
                                        <form @submit.prevent="update(comment)" method="post">
                                            <div class="form-floating">
                                                <textarea class="form-control" v-model="comment.comment" placeholder="What are you thoughts" id="floatingTextarea2" style="height: 100px"></textarea>
                                                <label for="floatingTextarea2">Your suggest comments?</label>
                                            </div>
                                            <span class="text-danger fw-bolder" v-if="error.edit">
                                                Comment <span v-text="error.edit"/>
                                            </span>
                                            <div class="d-flex justify-content-end mt-3">
                                                <button class="btn btn-secondary">Update</button>
                                            </div>
                                        </form>
                                    </div>
                                    <div class="row ms-5">
                                        <div class="col-12">
                                            <div v-for="child in child_comments" :key="child.id">
                                                <div v-if="child.parent_id == comment.id">                                                    
                                                    <div class="d-flex mb-2">
                                                        <router-link :to="`/profile/`+child.user_id" class="text-decoration-none text-black">
                                                            <span v-if="getUser(child).image_data">
                                                                <img :src="`${axios.defaults.baseURL}/uploads/`+JSON.parse(getUser(child).image_data).id" height="50px" width="50px" class="rounded-circle me-2">
                                                            </span>
                                                            <span v-else>
                                                                <img src="@/assets/user.png" height="50px" width="50px" class="rounded-circle me-2">
                                                            </span>
                                                        </router-link>
                                                        <div class="ms-3">
                                                            <router-link :to="`/profile/`+child.user_id" class="text-decoration-none text-black"><p class="mb-0 fw-bold text-capitalize"> {{ getUser(child).name }}</p></router-link>
                                                            <router-link :to="`/profile/`+child.user_id" class="text-decoration-none text-black"><span class="txt-color">{{ child.created_at | moment("from", "now", true) }} age</span></router-link>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col-12">
                                                            <p style="font-weight:500;background-color:#e4e5e7;" class="p-2 rounded">{{ child.comment }}</p>
                                                        </div>
                                                        <div v-if="currentUserId">
                                                            <div v-if="currentUserId == child.user_id">
                                                                <div class="col-12 justify-content-end">
                                                                    <div class="d-flex justify-content-end align-items-center">
                                                                        <button @click.prevent="showChildEditForm(child.id)" :class="`btn btn-warning me-2 child-edit-btn-`+child.id">Edit</button>
                                                                        <button @click.prevent="commentDestroy(child.id)" class="btn btn-danger" data-method="delete" data-confirm="Are you sure">Delete</button>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div :class="`mt-4 d-none child-edit-form child-edit-form-`+child.id">
                                                            <form @submit.prevent="update(child)" method="post">
                                                                <div class="form-floating">
                                                                    <textarea class="form-control" v-model="child.comment" placeholder="What are you thoughts" id="floatingTextarea2" style="height: 100px"></textarea>
                                                                    <label for="floatingTextarea2">Your suggest comments?</label>
                                                                </div>
                                                                <span class="text-danger fw-bolder" v-if="error.child">
                                                                    Comment <span v-text="error.child"/>
                                                                </span>
                                                                <div class="d-flex justify-content-end mt-3">
                                                                    <button class="btn btn-secondary">Update</button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
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
import LoginNav from '@/components/Common/LoginNav.vue'
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
        NavBar,
    },
    data(){
        return{
            post: '',
            users: '',
            photo: '',
            count: '',
            comments: '',
            child_comments: '',
            form:{
                comment: '',
                reply_commet: '',
                edit: '',
            },
            error: {
                comment: '',
                reply: '',
                edit: '',
                child: '',
            },
            latestPost: '',
            token: localStorage.getItem('token'),
            currentUserId: localStorage.getItem('current_user_id'),
        }
    },
    created(){
        this.view();
        this.showComment();
        this.replyComment();
    },
    watch: {
        $route(){
            this.view();
            this.showComment();
            this.replyComment();
        }
    },
    methods:{
        view(){
            this.axios.get(`/posts/${this.$route.params.id}`,{ headers: { Authorization: this.token } })
            .then(response =>{
                this.post = response.data.post;
                this.latestPost = response.data.latest;
                this.users = response.data.users;
                this.count = response.data.count;
                this.photo = JSON.parse(this.post.image_data).id
            })
        },
        showEditForm(id){
            $(`.edit-form`).addClass('d-none');
            $(`.reply-form`).addClass('d-none');
            $(`.child-edit-form`).addClass('d-none');
            $(`.edit-form-${id}`).toggleClass('d-none');
            this.clear();
        },
        showReplyForm(id){
            $(`.reply-form`).addClass('d-none');    
            $(`.edit-form`).addClass('d-none');
            $(`.child-edit-form`).addClass('d-none');
            $(`.reply-form-${id}`).toggleClass('d-none');
            this.clear();
        },
        showChildEditForm(id){
            $(`.reply-form`).addClass('d-none');    
            $(`.edit-form`).addClass('d-none');
            $(`.child-edit-form`).addClass('d-none');
            $(`.child-edit-form-${id}`).toggleClass('d-none');
            this.clear();
        },
        clear(){
            this.error.reply = ""
            this.error.comment = ""
            this.error.edit = ""
            this.error.child = ""
            this.showComment();
            this.replyComment();
        },
        showComment(){
            this.axios.get(`/comments/${this.$route.params.id}`,{ headers: { Authorization: this.token } })
            .then(response => this.comments = response.data)
        },
        replyComment(){
            this.axios.get(`comments/child/reply`,{headers : { Authorization: this.token}})
            .then(response => this.child_comments = response.data)
        },
        store(){
            const form = new FormData()
            form.append('comment',this.form.comment)
            form.append('user_id',this.currentUserId)
            form.append('post_id',this.post.id) 
            form.append('parent_id', '')
            this.axios.post(`/comments`, form, { headers: { Authorization: this.token } })
            .then(() => {
                this.showComment();
                this.error.comment = ""
                this.form.comment = ""
                Toast.fire({
                    icon: 'success',
                    title: 'Comment Added successfully!'
                });
                this.$router.push({name: 'postDetail'});
            })
            .catch(error => error.response.data.comment ? this.error.comment = error.response.data.comment[0] : this.error.comment='')
        },
        reply(id){
            const form = new FormData()
            form.append('comment',this.form.reply_commet)
            form.append('user_id',this.currentUserId)
            form.append('post_id',this.post.id) 
            form.append('parent_id', id)
            this.axios.post(`/comments/reply`,form,{ headers: { Authorization: this.token }})
            .then( () => {
                this.replyComment();
                this.error.reply = ""
                this.form.reply_commet = ""
                Toast.fire({
                    icon: 'success',
                    title: 'Comment Reply successfully!'
                });
                $(`.reply-form-${id}`).addClass('d-none');
                this.$router.push({name: 'postDetail'});
            })
            .catch( error => {
                error.response.data.reply.comment ? this.error.reply = error.response.data.reply.comment[0] : this.error.reply=''
            })
        },
        update(comment){
            const form = new FormData()
            form.append('comment',comment.comment)
            this.axios.put(`comments/${comment.id}`,form,{ headers: { Authorization: this.token }})
            .then(() => {
                Toast.fire({
                    icon: 'success',
                    title: 'Comment Updated successfully!'
                });
                $(`.edit-form`).addClass('d-none');
                $(`.child-edit-form`).addClass('d-none');
            })
            .catch(error => {
                error.response.data.comment ? this.error.edit = error.response.data.comment[0] : this.error.edit='' 
                error.response.data.comment ? this.error.child = error.response.data.comment[0] : this.error.child = ''
            })
        },
        getUser(post){
            const postUserValues = this.users.filter(user => user.id === post.user_id)
            let user

            postUserValues.forEach(function (element) {
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
                    this.$router.push({name: 'home'});
                });
                }
            });
        },
        commentDestroy(id){
            Swal.fire({
                title: "Are you sure?",
                icon: "warning",
                showCancelButton: true,
                confirmButtonColor: "#3085d6",
                cancelButtonColor: "#d33",
                confirmButtonText: "Delete!",
            }).then((result) => {
                if (result.isConfirmed) {
                this.axios.delete(`comments/${id}`,{ headers: { Authorization: this.token } }).then(() => {
                    this.showComment();
                    this.replyComment();
                    Toast.fire({
                        icon: 'success',
                        title: 'Comment Deleted successfully!'
                    });
                });
                }
            });
        },
    },
}
</script>