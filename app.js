// THE DREAM LIBRARY
// Main website application


// ================================
// PAGE NAVIGATION
// ================================

function showPage(pageId) {

  const pages =
    document.querySelectorAll(".page");

  pages.forEach(function(page) {
    page.classList.remove("active");
  });

  const selectedPage =
    document.getElementById(pageId);

  if (selectedPage) {
    selectedPage.classList.add("active");
  }

  window.scrollTo(0, 0);


  // LOAD MY DREAMS

  if (pageId === "my-dreams") {

    if (typeof loadMyDreams === "function") {
      loadMyDreams();
    }

  }


  // LOAD PUBLIC DREAMS

  if (pageId === "library") {

    if (typeof loadPublicDreams === "function") {
      loadPublicDreams();
    }

  }

}


// ================================
// RECORD DREAM
// ================================

function recordDream() {

  showPage("recorder");

}


// ================================
// EXPLORE DREAMS
// ================================

function exploreDreams() {

  showPage("library");

}
