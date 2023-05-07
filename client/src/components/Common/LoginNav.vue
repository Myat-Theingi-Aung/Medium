<template>
    <div id="app">
        <nav class="navbar border-bottom border-dark-50 position-fixed top-0 start-0 w-100" style="background-color:#fff;z-index:2;border-bottom:1px solid rgba(242, 242, 242, 1);z-index:2;">
            <div class="container-fluid py-2 d-flex justify-content-between align-items-center">
                <div class="d-flex align-items-center">
                    <a class="navbar-brand ps-3 pe-1 py-0 fs-4 fw-bold" href="/">
                        <svg viewBox="0 0 1043.63 592.71" style="height:25px"><g data-name="Layer 2"><g data-name="Layer 1"><path d="M588.67 296.36c0 163.67-131.78 296.35-294.33 296.35S0 460 0 296.36 131.78 0 294.34 0s294.33 132.69 294.33 296.36M911.56 296.36c0 154.06-65.89 279-147.17 279s-147.17-124.94-147.17-279 65.88-279 147.16-279 147.17 124.9 147.17 279M1043.63 296.36c0 138-23.17 249.94-51.76 249.94s-51.75-111.91-51.75-249.94 23.17-249.94 51.75-249.94 51.76 111.9 51.76 249.94"></path></g></g></svg>
                    </a>
                    <form @submit.prevent="searchPost" method="get" id="form">
                        <div class="d-none d-md-flex search-div align-items-center p-2">
                            <div class="mx-2">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none"><path fill-rule="evenodd" clip-rule="evenodd" d="M4.1 11.06a6.95 6.95 0 1 1 13.9 0 6.95 6.95 0 0 1-13.9 0zm6.94-8.05a8.05 8.05 0 1 0 5.13 14.26l3.75 3.75a.56.56 0 1 0 .8-.79l-3.74-3.73A8.05 8.05 0 0 0 11.04 3v.01z" fill="currentColor"></path></svg>
                            </div>
                            <input     
                                @keyup.enter="searchPost"                          
                                type="text"
                                name="search"
                                v-model="search"
                                class="search border border-0"
                                id="file1"
                                placeholder="Search Medium"
                            />
                        </div>
                    </form>
                </div>
                <ul class="d-flex align-items-center m-0">
                    <li class="d-md-none nav-item list-unstyled pe-4">
                        <a class="nav-link txt-color search-btn"  href="#">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" aria-label="Search"><path fill-rule="evenodd" clip-rule="evenodd" d="M4.1 11.06a6.95 6.95 0 1 1 13.9 0 6.95 6.95 0 0 1-13.9 0zm6.94-8.05a8.05 8.05 0 1 0 5.13 14.26l3.75 3.75a.56.56 0 1 0 .8-.79l-3.74-3.73A8.05 8.05 0 0 0 11.04 3v.01z" fill="currentColor"></path></svg>
                        </a>
                    </li>
                    <li v-if="this.currentUserRole == 'admin'" class="d-none d-md-block nav-item list-unstyled pe-3">
                        <a class="nav-link txt-color d-flex align-items-center" href="/users">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" aria-label="Profile"><circle cx="12" cy="7" r="4.5" stroke="currentColor"></circle><path d="M3.5 21.5v-4.34C3.5 15.4 7.3 14 12 14s8.5 1.41 8.5 3.16v4.34" stroke="currentColor" stroke-linecap="round"></path></svg>
                            <span>Users</span>
                        </a>
                    </li>
                    <li class="d-none d-md-block nav-item list-unstyled pe-3 ">
                        <a class="nav-link txt-color d-flex align-items-center" href="/post/create">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="none" aria-label="Write"><path d="M14 4a.5.5 0 0 0 0-1v1zm7 6a.5.5 0 0 0-1 0h1zm-7-7H4v1h10V3zM3 4v16h1V4H3zm1 17h16v-1H4v1zm17-1V10h-1v10h1zm-1 1a1 1 0 0 0 1-1h-1v1zM3 20a1 1 0 0 0 1 1v-1H3zM4 3a1 1 0 0 0-1 1h1V3z" fill="currentColor"></path><path d="M17.5 4.5l-8.46 8.46a.25.25 0 0 0-.06.1l-.82 2.47c-.07.2.12.38.31.31l2.47-.82a.25.25 0 0 0 .1-.06L19.5 6.5m-2-2l2.32-2.32c.1-.1.26-.1.36 0l1.64 1.64c.1.1.1.26 0 .36L19.5 6.5m-2-2l2 2" stroke="currentColor"></path></svg>
                            <span>Write</span>
                        </a>
                    </li>
                    <li class="nav-item list-unstyled">
                        <div class="dropdown border border-0">
                            <a class="btn dropdown-toggle border border-0" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <span v-if="JSON.parse(currentUserImage) == null">
                                    <img src="@/assets/user.png" alt="" class="rounded-circle" width="30px" height="30px">
                                </span>
                                <span v-else>
                                    <img :src="`${axios.defaults.baseURL}/uploads/`+JSON.parse(currentUserImage).id" alt="" class="rounded-circle" width="30px" height="30px">
                                </span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li class="d-block d-md-none">
                                    <a class="dropdown-item py-2 txt-color" href="/post/create">
                                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" aria-label="Write"><path d="M14 4a.5.5 0 0 0 0-1v1zm7 6a.5.5 0 0 0-1 0h1zm-7-7H4v1h10V3zM3 4v16h1V4H3zm1 17h16v-1H4v1zm17-1V10h-1v10h1zm-1 1a1 1 0 0 0 1-1h-1v1zM3 20a1 1 0 0 0 1 1v-1H3zM4 3a1 1 0 0 0-1 1h1V3z" fill="currentColor"></path><path d="M17.5 4.5l-8.46 8.46a.25.25 0 0 0-.06.1l-.82 2.47c-.07.2.12.38.31.31l2.47-.82a.25.25 0 0 0 .1-.06L19.5 6.5m-2-2l2.32-2.32c.1-.1.26-.1.36 0l1.64 1.64c.1.1.1.26 0 .36L19.5 6.5m-2-2l2 2" stroke="currentColor"></path></svg>
                                        <span class="ms-3">Write</span>
                                    </a>
                                </li>
                                <div class="d-block d-md-none" style="background-color: rgb(230, 230, 230);margin: 8px 16px;height:2px;width:24px;"></div>
                                <li>
                                    <router-link class="dropdown-item py-2 txt-color" onclick="window.location.reload(true);" :to="`/profile/`+currentUserId">
                                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" aria-label="Profile"><circle cx="12" cy="7" r="4.5" stroke="currentColor"></circle><path d="M3.5 21.5v-4.34C3.5 15.4 7.3 14 12 14s8.5 1.41 8.5 3.16v4.34" stroke="currentColor" stroke-linecap="round"></path></svg>
                                        <span class="ms-3">Profile</span>
                                    </router-link>
                                </li>
                                <li class="border-bottom pb-2">
                                    <a class="dropdown-item py-2 txt-color" href="/">
                                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" aria-label="Lists"><path d="M6.44 6.69h0a1.5 1.5 0 0 1 1.06-.44h9c.4 0 .78.16 1.06.44l.35-.35-.35.35c.28.28.44.66.44 1.06v14l-5.7-4.4-.3-.23-.3.23-5.7 4.4v-14c0-.4.16-.78.44-1.06z" stroke="currentColor"></path><path d="M12.5 2.75h-8a2 2 0 0 0-2 2v11.5" stroke="currentColor" stroke-linecap="round"></path></svg>
                                        <span class="ms-3">Lists</span>
                                    </a>
                                </li>
                                <li>
                                    <router-link id="importBtn" data-bs-toggle="modal" data-bs-target="#importModal" class="dropdown-item py-2 txt-color" to="">
                                        <svg width="22" height="22" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><path d="M128 64c0-35.3 28.7-64 64-64H352V128c0 17.7 14.3 32 32 32H512V448c0 35.3-28.7 64-64 64H192c-35.3 0-64-28.7-64-64V336H302.1l-39 39c-9.4 9.4-9.4 24.6 0 33.9s24.6 9.4 33.9 0l80-80c9.4-9.4 9.4-24.6 0-33.9l-80-80c-9.4-9.4-24.6-9.4-33.9 0s-9.4 24.6 0 33.9l39 39H128V64zm0 224v48H24c-13.3 0-24-10.7-24-24s10.7-24 24-24H128zM512 128H384V0L512 128z"/></svg>
                                        <span class="ms-3">Import</span>
                                    </router-link>
                                </li>
                                <li class="border-bottom pb-2">
                                    <a class="dropdown-item py-2 txt-color" @click.prevent="exportPost" href="/">
                                        <svg width="24" height="24" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 640 512"><path d="M32 64C32 28.7 60.7 0 96 0H256V128c0 17.7 14.3 32 32 32H416V288H248c-13.3 0-24 10.7-24 24s10.7 24 24 24H416V448c0 35.3-28.7 64-64 64H96c-35.3 0-64-28.7-64-64V64zM416 336V288H526.1l-39-39c-9.4-9.4-9.4-24.6 0-33.9s24.6-9.4 33.9 0l80 80c9.4 9.4 9.4 24.6 0 33.9l-80 80c-9.4 9.4-24.6 9.4-33.9 0s-9.4-24.6 0-33.9l39-39H416zm0-208H288V0L416 128z"/></svg>
                                        <span class="ms-3">Export</span>
                                    </a>
                                </li>
                                <li>
                                    <router-link @click="logout" to="" class="dropdown-item py-2 cursor-pointer txt-color">
                                        <svg width="22" height="22" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><path d="M160 96c17.7 0 32-14.3 32-32s-14.3-32-32-32H96C43 32 0 75 0 128V384c0 53 43 96 96 96h64c17.7 0 32-14.3 32-32s-14.3-32-32-32H96c-17.7 0-32-14.3-32-32l0-256c0-17.7 14.3-32 32-32h64zM504.5 273.4c4.8-4.5 7.5-10.8 7.5-17.4s-2.7-12.9-7.5-17.4l-144-136c-7-6.6-17.2-8.4-26-4.6s-14.5 12.5-14.5 22v72H192c-17.7 0-32 14.3-32 32l0 64c0 17.7 14.3 32 32 32H320v72c0 9.6 5.7 18.2 14.5 22s19 2 26-4.6l144-136z"/></svg>
                                        <span class="ms-3">Logout</span>
                                    </router-link>
                                </li>
                            </ul>
                        </div>
                    </li>
                </ul>
            </div>
        </nav>
        <!-- import modal -->
        <div class="modal fade" id="importModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="image.png" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-body px-3">
                        <div class="d-flex justify-content-between align-items-center pt-3 mb-4">
                            <h1 class="modal-title fs-4" id="image.png">Import Post Data</h1>
                            <button @click.prevent="cancle" type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <form id="dataImport" method="post" @submit.prevent="importPost">
                            <div class="form-group mb-4">
                                <input ref="file" id="dataImport" type="file" @change="onFileSelected" name="file" class="form-control">
                                <span class="text-danger fw-bolder" v-if="this.error">
                                    <span v-text="this.error"/>
                                </span>
                            </div>
                            
                            <button class="btn btn-success float-end import">Import</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
</template>

<script>
import Swal from "sweetalert2"
import $ from 'jquery'
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
        name: "LoginNav",

        data(){
            return{
                file : '',
                search: '',
                error: '',
                token: localStorage.getItem("token"),
                currentUserName: localStorage.getItem("current_user_name"),
                currentUserId: localStorage.getItem("current_user_id"),
                currentUserImage: localStorage.getItem("current_user_image"),
                currentUserRole: localStorage.getItem("current_user_role"),
            }
        },
        methods: {
            searchPost(){
                this.$emit("search", this.search)
            },
            onFileSelected(event) {
                this.file = event.target.files[0];
            },
            importPost(){
                const form = new FormData()
                form.append('file',this.file)
                this.axios.post(`/post/import`,form,{ headers: { Authorization: this.token } })
                .then(() => {
                    $("#importModal").hide();
                    $('.modal-backdrop').remove();
                    $('body').removeClass( "modal-open" );
                    Toast.fire({
                        icon: 'success',
                        title: 'Post Import Successfully'
                    });
                    this.$refs.file.value = null;
                    this.error = '';
                    window.location.reload();
                })
                .catch(error => this.error = error.response.data.error)
            },
            exportPost(){
                this.axios.post(`/post/export`,{},{ headers: { Authorization: this.token } })
                .then(response => {
                    const url = URL.createObjectURL(new Blob([response.data], {
                    type: 'application/vnd.ms-excel'
                    }))
                    const link = document.createElement('a')
                    link.href = url
                    link.setAttribute('download', 'exportPost.csv')
                    document.body.appendChild(link)
                    link.click()
                })
            },
            cancle(){
                this.$refs.file.value = null;
                this.error = ''
            },
            logout(){
                localStorage.removeItem("token")
                localStorage.removeItem("current_user_id")
                localStorage.removeItem("current_user_role")
                localStorage.removeItem("current_user_name")
                localStorage.removeItem("forgot_user_id")
                localStorage.removeItem("current_user_email")
                this.$router.push('/')
                window.location.reload();
            }
        }
    }
$(document).ready(function(){
    $('#importBtn').click(function(){
        $('.import').prop('disabled', true);
    })
    $("#dataImport").change(function(){
        $('.import').prop('disabled', false);
    });
})
</script>

<style>
.search-div{
    background: rgba(250, 250, 250, 1);
    border-radius: 20px;
    width: 240px;
}
  
.search-sp-div{
    border-radius: 20px;
    border: 1px solid black;
}
  
.search-sp-div input{
    outline: none;
}
  
.search-div .search{
    outline: none;
    background: rgba(250, 250, 250, 1);
    font-size: 14px;
    font-weight: 500;
}
</style>