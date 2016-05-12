(doc) ->
  if doc.type and doc.time
    emit [doc.type,doc.time.substring(0,4),doc.time.substring(5,7),doc.time.substring(8,10),doc.time.substring(11,13), doc.time.substring(14,16)], null
