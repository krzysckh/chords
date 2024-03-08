/* license: MIT */

const searchbar = document.createElement("input");
const list = document.getElementsByTagName("ul")[0];
const elements = [...list.children].map(el => { return {title: el.firstChild.firstChild.data, el: el} });

const init = () => {
    const body = document.body;
    searchbar.type = "text";
    searchbar.oninput = search;

    body.prepend(document.createElement("br"));
    body.prepend(searchbar);
    searchbar.focus();
    searchbar.select();
}

const search = (_) => {
    const query = searchbar.value;
    const sorted = query == "" ? elements : fuzzysort.go(query, elements, { keys: ["title"] }).map(o => o.obj);

    console.log(sorted);
    [...list.children].forEach(e => list.removeChild(e));
    sorted.forEach(e => list.appendChild(e.el));
}

init();
