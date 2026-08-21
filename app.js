// THE DREAM LIBRARY
// Main website application


// PAGE NAVIGATION

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


  // LOAD USER'S DREAMS

  if (pageId === "my-dreams") {

    if (typeof loadMyDreams === "function") {
      loadMyDreams();
    }

  }

}


// RECORD DREAM

function recordDream() {

  showPage("recorder");

}


// EXPLORE DREAMS

function exploreDreams() {

  showPage("library");

}
