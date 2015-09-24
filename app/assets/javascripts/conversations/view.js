var ConversationsView = {
  removeConversation: function(eventTarget){
    $(eventTarget).closest("[data-li=conversation]").remove();
  },
  showMessage: function(eventTarget, newMessage){
    $("[data-ul=messages]").append(newMessage);
  }
  setTimeStamp: function(selector){
  var d = new Date();
  $(selector).data("timestamp", d.getTime().toString());
  }
};
