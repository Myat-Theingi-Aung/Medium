import Vue from 'vue'
import VueRouter from 'vue-router'
import PostCreateView from '@/views/post/CreateView.vue'
import PostEidtView from '@/views/post/EditView.vue'
import PostIndexView from '@/views/post/IndexView.vue'
import PostShowView from '@/views/post/ShowView.vue'
import LoginView from '@/views/auth/LoginView.vue'
import RegisterView from '@/views/auth/RegisterView.vue'
import CategoryView from '@/views/post/CategoryListView.vue'
import ProfileView from '@/views/profile/IndexView.vue'
import PageNotFound from '@/views/NotFoundView.vue'
import ForgotPasswordView from '@/views/auth/ForgotPasswordView.vue'
import ResetPasswordView from '@/views/auth/ResetPasswordView.vue'
import UserIndexView from '@/views/users/IndexView.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'home',
    component: PostIndexView
  },
  {
    path: '/forgot/password',
    name: 'forgot',
    component: ForgotPasswordView
  },
  {
    path: '/reset/password',
    name: 'reset',
    component: ResetPasswordView
  },
  {
    path: '/login',
    name: 'login',
    component: LoginView
  },
  {
    path: '/register',
    name: 'register',
    component: RegisterView
  },
  {
    path: '/post/create',
    name: 'postCreate',
    component: PostCreateView
  },
  {
    path: '/posts/:id/edit',
    name: 'postEdit',
    component: PostEidtView,
  },
  {
    path: '/posts/:id',
    name: 'postDetail',
    component: PostShowView,
  },
  {
    path: '/category/:name',
    name: 'category',
    component: CategoryView
  },
  {
    path: '/profile/:id',
    name: 'profile',
    component: ProfileView
  },
  {
    path: '/users',
    name: 'users',
    component: UserIndexView
  },
  { 
    path: '/:catchAll(.*)*', 
    name: 'notfound',
    component: PageNotFound 
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
