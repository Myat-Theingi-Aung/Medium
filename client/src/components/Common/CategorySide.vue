<template>
<div>
    <h5>CATEGORY</h5>
    <div class="mt-4 pb-4">
        <span v-for="category in categories" :key="category.id">
            <router-link :to="`/category/`+category.name" class="border mb-2 me-1 rounded text-capitalize d-inline-block text-decoration-none px-2 px-md-3 py-2" style="color:rgba(117, 117, 117, 1);" >{{ category.name }}</router-link>
        </span>
    </div>
    <div class="d-lg-block d-none border-bottom">
        <p class="d-none"></p>
    </div>
    <div class="mt-4 d-none d-lg-block">
        <a class="text-decoration-none d-inline-block me-4 fs-6 mb-2" style="color:rgba(117, 117, 117, 1);" href="#">Help</a>
        <a class="text-decoration-none d-inline-block me-4 fs-6 mb-2" style="color:rgba(117, 117, 117, 1);" href="#">Status</a>
        <a class="text-decoration-none d-inline-block me-4 fs-6 mb-2" style="color:rgba(117, 117, 117, 1);" href="#">Writers</a>
        <a class="text-decoration-none d-inline-block me-4 fs-6 mb-2" style="color:rgba(117, 117, 117, 1);" href="#">Blog</a>
        <a class="text-decoration-none d-inline-block me-4 fs-6 mb-2" style="color:rgba(117, 117, 117, 1);" href="#">Carrers</a>
        <a class="text-decoration-none d-inline-block me-4 fs-6 mb-2" style="color:rgba(117, 117, 117, 1);" href="#">Privacy</a>
        <a class="text-decoration-none d-inline-block me-4 fs-6 mb-2" style="color:rgba(117, 117, 117, 1);" href="#">Terms</a>
        <a class="text-decoration-none d-inline-block me-4 fs-6 mb-2" style="color:rgba(117, 117, 117, 1);" href="#">About</a>
        <a class="text-decoration-none d-inline-block me-4 fs-6 mb-2" style="color:rgba(117, 117, 117, 1);" href="#">Text to speech</a>
    </div>
</div>
</template>

<script>
    export default {
        name: "CategorySide",
        props: ['categories']
    }
</script>