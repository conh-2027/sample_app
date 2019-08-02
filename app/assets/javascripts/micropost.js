$("#micropost_picture").bind("change", function(){
  var size_in_magabytes = this.file[0].size/1024/1024;
  if(size_in_magabytes > 5){
    alert(I18n.t("alert.size"));
  }
});
