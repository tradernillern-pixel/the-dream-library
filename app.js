// THE DREAM LIBRARY
// Main website application

function showPage(pageId) {

  const pages = document.querySelectorAll(".page");

  pages.forEach(function(page) {
    page.classList.remove("active");
  });

  const selectedPage =
    document.getElementById(pageId);

  if (selectedPage) {
    selectedPage.classList.add("active");
  }

  window.scrollTo(0, 0);
}


// Temporary button functions

function recordDream() {
  showPage("recorder");
}

function exploreDreams() {
  showPage("library");
}
