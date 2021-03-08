$(document).ready(function(){
    //event handlers for LI(s)
    $("#vamc_directory_select").change (function(e) {
        //set VISN and TYPE filters back to - Select
        document.getElementById('vamc_directory_visn_select').value = '- Select -';
        document.getElementById('vamc_type_select').value = '- Select -';
        var curUrl = window.location.href;
        let vamcId = e.target.options[e.target.selectedIndex].value;
        curUrl = stripQsParams(curUrl);
        let newUrl = `${curUrl}?vamc=${vamcId}`;
        window.location.href = newUrl;
    });

    $("#vamc_directory_visn_select").change (function(e) {
        document.getElementById('vamc_directory_select').value = '';
        let type =  document.getElementById('vamc_type_select').value;
        var curUrl = window.location.href;
        let visnId = e.target.options[e.target.selectedIndex].value;
        curUrl = stripQsParams(curUrl);
        let newUrl = `${curUrl}?visn=${visnId}`;
        if (type.length > 0){
            newUrl += `&type=${type}`;
        }
        window.location.href = newUrl;
    });

    $("#vamc_type_select").change (function(e) {
        document.getElementById('vamc_directory_select').value = '';
        var curUrl = window.location.href;
        let type = this.options[e.target.selectedIndex].text;
        let visnId = e.target.options[e.target.selectedIndex].value;
        curUrl = stripQsParams(curUrl);
        let newUrl = `${curUrl}?type=${type}`;
        if(visnId.length > 0){
            newUrl += `&visn=${visnId}`;
        }
        window.location.href = newUrl;
    });

    function stripQsParams(s){
        if (s.includes("?")){
            var pos1 = s.indexOf("?");
            return s.substring(0, pos1);
        }
        return s;
    }
});

