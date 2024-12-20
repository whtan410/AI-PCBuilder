<template>
  <div class="container">
    <template v-for="(section, index) in sections" :key="section.id">
      <GlitchGif
        :text="section.dynamicText"
        :showButton="section.showButton"
        :opac="section.opacity"
        :wrapperHeight="section.wrapperHeight"
      />
      <v-card>{{ section.staticText }}</v-card>

      <!-- About Section -->
      <template v-if="index === 1">
        <v-row justify="center" class="about-section" no-gutters>
          <v-col cols="12" md="4" sm="4" class="d-flex">
            <div class="content-wrapper">
              <Carousels />
            </div> 
          </v-col> 
          <v-col cols="12" md="7" sm="2" class="d-flex">
            <div class="content-wrapper">
              <v-card class="about-us-container bitstream text-high-emphasis">
           
              At MoonArch, we're passionate about empowering gamers, content creators, and tech enthusiasts to bring their dream PCs to life.
              Our innovative platform makes it easy to design and customize your perfect machine, with a user-friendly interface and expert guidance every step of the way.
              With a focus on quality, performance, and community, we're dedicated to delivering an unparalleled PC building experience.<br><br>

              Whether you're a seasoned pro or just starting out, our platform is designed to help you create a PC that meets your unique needs and budget.<br>

              From gaming and video editing to streaming and content creation, we've got the tools and expertise to help you achieve your goals.<br><br>

              With a vast library of components, expert advice, and a supportive community, you'll be able to bring your vision to life and take your computing experience to the next level.
              Join the MoonArch community today and discover a new way to build, upgrade, and enjoy your ultimate gaming and computing rig.
           
            </v-card>
            </div>
          </v-col>
        </v-row>
        <div class="post-about-spacer"></div>
      </template>

      <!-- Spacer before Contact -->
      <div v-if="index === 2" class="section-spacer"></div>
    </template>

    <div v-for="(location, index) in locations" 
         :key="'loc-' + index"
         class="map-container-wrapper bitstream">
      <MapBox v-bind="{ ...location, index }" />
    </div>
  </div>
</template>

<script setup>
  import GlitchGif from '@/components/homepage/GlitchGif.vue'
  import MapBox from '@/components/homepage/Mapbox.vue'
  import Carousels from '@/components/homepage/Carousels.vue'

  const sections = ref([
  {
    id: 'welcome',
    dynamicText: 'WELCOME TO MOONARCH',
    opacity: 100,
    showButton: true,
    wrapperHeight: '100vh',
    staticText: ''
  },
  {
    id: 'about',
    dynamicText: 'ABOUT US',
    opacity: 100,
    showButton: false,
    wrapperHeight: '30vh',
    staticText: ''
  },
  {
    id: 'contact',
    dynamicText: 'CONTACT US',
    opacity: 100,
    showButton: false,
    wrapperHeight: '30vh',
    staticText: ''
  }
])

// Integrated useLocations
const locations = ref([
  {
    address: 'Menara Gamuda,Pj Trade Centre, No. 8, Jalan PJU 8/8A, Damansara Perdana, 47820 Petaling Jaya, Selangor',
    headline: 'Damansara Perdana HQ',
    address1: 'Pj Trade Centre, No. 8',
    address2: 'Jalan PJU 8/8A, Damansara Perdana',
    address3: '47820 Petaling Jaya, Selangor',
    phone: '3-4565 4321',
    email: 'gamudahq@gmail.com'
  },
  {
    address: 'Gamuda Learning Centre (GLC), 53-61, Jalan SS 22/23, Damansara Jaya, 47400 Petaling Jaya, Selangor',
    headline: 'Petaling Jaya Branch',
    address1: '53-61',
    address2: 'Jalan SS 22/23, Damansara Jaya',
    address3: '47400 Petaling Jaya, Selangor',
    phone: '3-1415 9265',
    email: 'gamudalearningcentre@gmail.com'
  },
  {
    address: 'Universiti Tenaga Nasional (UNITEN), Jalan Wawasan, 43009 Kajang, Selangor',
    headline: 'Kajang Branch',
    address1: '1, Jalan Wawasan',
    address2: '43009 Kajang',
    address3: 'Selangor',
    phone: '3-2132 2324',
    email: 'gamudafarfaraway@gmail.com'
  }
])
</script>

<style scoped>
  @import url('@/assets/BitStreamFont/stylesheet.css');
  @import url('@/assets/BPdotsFont/stylesheet.css');


  /* .background-color{
    background: #3e0054;
  } */

  .container {
    position: relative;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: flex;
    overflow: hidden;
    background: linear-gradient(rgba(0, 0, 0, 0.8), 
                                rgba(0, 0, 0, 0.2)), 
                                url("https://mir-s3-cdn-cf.behance.net/project_modules/fs/223e6792880429.5e569ff84ebef.gif");
    background-repeat: no-repeat;
    background-size: cover;
    padding-bottom: 100px;
  }

  .map-container-wrapper {
    margin: 20px 0;
    width: 100%;
    display: flex;
    justify-content: center;
  }

  @media (max-width: 959px) {
    .map-container-wrapper {
      margin: 15px 0;
      padding: 0 10px;
    }
  }

  .about-us-container{
    border-radius: 5%;
    box-shadow: 0 0 20px rgba(255, 75, 183, 0.7);
    padding: 20px;
    width: 80%;
    background-color: rgba(62, 0, 84, 1);
    color: rgb(255, 255, 255);
    word-wrap: break-word;
    height: 100%;
    width: 100%;
    padding: 20px;
    overflow-y: auto;
    text-align: left;
    font-size: 1.15rem;
  }

  .section-spacer {
    height: 50px;  /* Reduced from 200px */
    width: 100%;
  }

  /* Optional: Add margin to the GlitchGif component for Contact Us */
  .glitch-gif-wrapper {
    margin-top: 50px;
  }

  /* If you want different spacing for different screen sizes */
  @media (max-width: 768px) {
    .section-spacer {
      height: 25px;  /* Reduced from 50px */
    }
  }

  .about-section {
    width: 100%;
    max-width: 1400px;
    margin: 0 auto;
    gap: 4px;
  }

  .content-wrapper {
    flex: 1;
    padding: 0 15px;
    height: 600px; /* Fixed height for both containers */
  }

  /* Responsive adjustments */
  @media (max-width: 960px) {
    .about-section {
      gap: 8px;
    }

    .content-wrapper {
      height: 500px;
      padding: 4px;
    }
  }

  @media (max-width: 600px) {
    .about-section {
      padding: 5px;
    }
  }

  .post-about-spacer {
    height: 200px;
    width: 100%;
  }

  @media (max-width: 768px) {
    .post-about-spacer {
      height: 50px;
    }
  }
</style>