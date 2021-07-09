#' Create a random Japanese (Kanji or Hiragana) string
#'
#' @description
#' Function to create a random Japanese (Kanji or Hiragana) string.
#'
#' @details
#' It is a random string, so it does not reflect the normal rules of Japanese.
#' In the case of hiragana, characters that do not normally appear at the beginning of a string, such as Sutegana and "n", will also appear at the beginning.
#'
#' Only the range of regular kanji is supported.
#'
#' @param length a positive number, the length of the output string.
#' @param size a positive number, the number of strings to output.
#' @param replace should sampling be with replacement?
#' @param moji Select the string to output. Select Kanji or Hiragana.
#'
#' @return a vector.
#'
#' @examples
#' rand_moji(length = 3, size = 3, moji = "kanji")
#' rand_moji(length = 3, size = 3, moji = "hiragana")
#' @export

rand_moji <- function(length, size, replace = TRUE, moji = c("kanji", "hiragana")){
  moji <- match.arg(moji)

  if(length(length) != 1 || length < 0){
    warning("length is a single value that accepts only positive integers.")
    return(NA)
  }
  if(length(size) != 1 || size < 0){
    warning("size is a single value that accepts only positive integers.")
    return(NA)
  }
  if(length(replace) != 1 || !is.logical(replace)){
    warning("replace is a single value that accepts only logical.")
    return(NA)
  }

  # list of kanji for common use (list of 2,136 kanji in Japanese).
  kanji <- c("\u4e9c", "\u54c0", "\u63e1", "\u6271", "\u4f9d", "\u5049", "\u5a01",
             "\u5c09", "\u6170", "\u70ba", "\u7dad", "\u7def", "\u9055", "\u4e95",
             "\u58f1", "\u9038", "\u7a32", "\u828b", "\u59fb", "\u9670", "\u96a0",
             "\u97fb", "\u6e26", "\u6d66", "\u5f71", "\u8a60", "\u92ed", "\u75ab",
             "\u60a6", "\u8b01", "\u8d8a", "\u95b2", "\u5bb4", "\u63f4", "\u708e",
             "\u7159", "\u733f", "\u7e01", "\u925b", "\u6c5a", "\u51f9", "\u5965",
             "\u62bc", "\u6b27", "\u6bb4", "\u7fc1", "\u6c96", "\u61b6", "\u4e59",
             "\u5378", "\u7a4f", "\u4f73", "\u5ac1", "\u5be1", "\u6687", "\u67b6",
             "\u798d", "\u7a3c", "\u7b87", "\u83ef", "\u83d3", "\u868a", "\u96c5",
             "\u9913", "\u4ecb", "\u584a", "\u58ca", "\u602a", "\u6094", "\u61d0",
             "\u6212", "\u62d0", "\u7686", "\u52be", "\u6168", "\u6982", "\u6daf",
             "\u8a72", "\u57a3", "\u5687", "\u6838", "\u6bbb", "\u7372", "\u7a6b",
             "\u8f03", "\u90ed", "\u9694", "\u5cb3", "\u639b", "\u6f5f", "\u559d",
             "\u62ec", "\u6e07", "\u6ed1", "\u8910", "\u8f44", "\u4e14", "\u5208",
             "\u4e7e", "\u51a0", "\u52d8", "\u52e7", "\u559a", "\u582a", "\u5bdb",
             "\u60a3", "\u61be", "\u63db", "\u6562", "\u68fa", "\u6b3e", "\u6b53",
             "\u6c57", "\u74b0", "\u7518", "\u76e3", "\u7de9", "\u7f36", "\u809d",
             "\u8266", "\u8cab", "\u9084", "\u9451", "\u9591", "\u9665", "\u542b",
             "\u9811", "\u4f01", "\u5947", "\u5c90", "\u5e7e", "\u5fcc", "\u65e2",
             "\u68cb", "\u68c4", "\u7948", "\u8ecc", "\u8f1d", "\u98e2", "\u9a0e",
             "\u9b3c", "\u507d", "\u5100", "\u5b9c", "\u622f", "\u64ec", "\u6b3a",
             "\u72a0", "\u83ca", "\u5409", "\u55ab", "\u8a70", "\u5374", "\u811a",
             "\u8650", "\u4e18", "\u53ca", "\u673d", "\u7aae", "\u7cfe", "\u5de8",
             "\u62d2", "\u62e0", "\u865a", "\u8ddd", "\u4eab", "\u51f6", "\u53eb",
             "\u5ce1", "\u6050", "\u606d", "\u631f", "\u6cc1", "\u72c2", "\u72ed",
             "\u77ef", "\u8105", "\u97ff", "\u9a5a", "\u4ef0", "\u51dd", "\u6681",
             "\u65a4", "\u7434", "\u7dca", "\u83cc", "\u895f", "\u8b39", "\u541f",
             "\u99c6", "\u611a", "\u865e", "\u5076", "\u9047", "\u9685", "\u5c48",
             "\u6398", "\u9774", "\u7e70", "\u6851", "\u52f2", "\u85ab", "\u50be",
             "\u5211", "\u5553", "\u5951", "\u6075", "\u6176", "\u61a9", "\u63b2",
             "\u643a", "\u6e13", "\u7d99", "\u830e", "\u86cd", "\u9d8f", "\u8fce",
             "\u9be8", "\u6483", "\u5091", "\u5039", "\u517c", "\u5263", "\u570f",
             "\u5805", "\u5acc", "\u61f8", "\u732e", "\u80a9", "\u8b19", "\u8ce2",
             "\u8ed2", "\u9063", "\u9855", "\u5e7b", "\u5f26", "\u7384", "\u5b64",
             "\u5f27", "\u67af", "\u8a87", "\u96c7", "\u9867", "\u9f13", "\u4e92",
             "\u5449", "\u5a2f", "\u5fa1", "\u609f", "\u7881", "\u4faf", "\u5751",
             "\u5b54", "\u5de7", "\u6052", "\u614c", "\u6297", "\u62d8", "\u63a7",
             "\u653b", "\u66f4", "\u6c5f", "\u6d2a", "\u6e9d", "\u7532", "\u786c",
             "\u7a3f", "\u7d5e", "\u7db1", "\u80af", "\u8352", "\u8861", "\u8ca2",
             "\u8cfc", "\u90ca", "\u9175", "\u9805", "\u9999", "\u525b", "\u62f7",
             "\u8c6a", "\u514b", "\u9177", "\u7344", "\u8170", "\u8fbc", "\u58be",
             "\u5a5a", "\u6068", "\u61c7", "\u6606", "\u7d3a", "\u9b42", "\u4f50",
             "\u5506", "\u8a50", "\u9396", "\u50b5", "\u50ac", "\u5bb0", "\u5f69",
             "\u683d", "\u6b73", "\u7815", "\u658e", "\u8f09", "\u5264", "\u54b2",
             "\u5d0e", "\u524a", "\u643e", "\u7d22", "\u932f", "\u64ae", "\u64e6",
             "\u5098", "\u60e8", "\u685f", "\u66ab", "\u4f3a", "\u523a", "\u55e3",
             "\u65bd", "\u65e8", "\u7949", "\u7d2b", "\u80a2", "\u8102", "\u8aee",
             "\u8cdc", "\u96cc", "\u4f8d", "\u6148", "\u6ecb", "\u74bd", "\u8ef8",
             "\u57f7", "\u6e7f", "\u6f06", "\u75be", "\u829d", "\u8d66", "\u659c",
             "\u716e", "\u906e", "\u86c7", "\u90aa", "\u52fa", "\u7235", "\u914c",
             "\u91c8", "\u5bc2", "\u6731", "\u6b8a", "\u72e9", "\u73e0", "\u8da3",
             "\u5112", "\u5bff", "\u9700", "\u56da", "\u6101", "\u79c0", "\u81ed",
             "\u821f", "\u8972", "\u916c", "\u919c", "\u5145", "\u67d4", "\u6c41",
             "\u6e0b", "\u7363", "\u9283", "\u53d4", "\u6dd1", "\u7c9b", "\u587e",
             "\u4fca", "\u77ac", "\u51c6", "\u5faa", "\u65ec", "\u6b89", "\u6f64",
             "\u76fe", "\u5de1", "\u9075", "\u5eb6", "\u7dd2", "\u53d9", "\u5f90",
             "\u511f", "\u5320", "\u5347", "\u53ec", "\u5968", "\u5bb5", "\u5c1a",
             "\u5e8a", "\u5f70", "\u6284", "\u638c", "\u6607", "\u6676", "\u6cbc",
             "\u6e09", "\u7126", "\u75c7", "\u785d", "\u7901", "\u7965", "\u79f0",
             "\u7ca7", "\u7d39", "\u8096", "\u885d", "\u8a1f", "\u8a54", "\u8a73",
             "\u9418", "\u4e08", "\u5197", "\u5270", "\u58cc", "\u5b22", "\u6d44",
             "\u7573", "\u8b72", "\u91b8", "\u9320", "\u5631", "\u98fe", "\u6b96",
             "\u89e6", "\u8fb1", "\u4f38", "\u4fb5", "\u5507", "\u5a20", "\u5bdd",
             "\u5be9", "\u614e", "\u632f", "\u6d78", "\u7d33", "\u85aa", "\u8a3a",
             "\u8f9b", "\u9707", "\u5203", "\u5c0b", "\u751a", "\u5c3d", "\u8fc5",
             "\u9663", "\u9162", "\u5439", "\u5e25", "\u708a", "\u7761", "\u7c8b",
             "\u8870", "\u9042", "\u9154", "\u9318", "\u968f", "\u9ac4", "\u5d07",
             "\u67a2", "\u636e", "\u6749", "\u6f84", "\u702c", "\u755d", "\u662f",
             "\u59d3", "\u5f81", "\u7272", "\u8a93", "\u8acb", "\u901d", "\u6589",
             "\u96bb", "\u60dc", "\u65a5", "\u6790", "\u7c4d", "\u8de1", "\u62d9",
             "\u6442", "\u7a83", "\u4ed9", "\u5360", "\u6247", "\u6813", "\u6f5c",
             "\u65cb", "\u7e4a", "\u85a6", "\u8df5", "\u9077", "\u9291", "\u9bae",
             "\u6f38", "\u7985", "\u7e55", "\u5851", "\u63aa", "\u758e", "\u790e",
             "\u79df", "\u7c97", "\u8a34", "\u963b", "\u50e7", "\u53cc", "\u55aa",
             "\u58ee", "\u635c", "\u6383", "\u633f", "\u66f9", "\u69fd", "\u71e5",
             "\u8358", "\u846c", "\u85fb", "\u906d", "\u971c", "\u9a12", "\u618e",
             "\u8d08", "\u4fc3", "\u5373", "\u4fd7", "\u8cca", "\u5815", "\u59a5",
             "\u60f0", "\u99c4", "\u8010", "\u6020", "\u66ff", "\u6cf0", "\u6ede",
             "\u80ce", "\u888b", "\u902e", "\u6edd", "\u5353", "\u629e", "\u62d3",
             "\u6ca2", "\u6fef", "\u8a17", "\u6fc1", "\u8afe", "\u4f46", "\u596a",
             "\u8131", "\u68da", "\u4e39", "\u5606", "\u6de1", "\u7aef", "\u80c6",
             "\u935b", "\u58c7", "\u5f3e", "\u6065", "\u75f4", "\u7a1a", "\u81f4",
             "\u9045", "\u755c", "\u84c4", "\u9010", "\u79e9", "\u7a92", "\u5ae1",
             "\u62bd", "\u8877", "\u92f3", "\u99d0", "\u5f14", "\u5f6b", "\u5fb4",
             "\u61f2", "\u6311", "\u773a", "\u8074", "\u8139", "\u8d85", "\u8df3",
             "\u52c5", "\u6715", "\u6c88", "\u73cd", "\u93ae", "\u9673", "\u6d25",
             "\u589c", "\u585a", "\u6f2c", "\u576a", "\u91e3", "\u4ead", "\u5075",
             "\u8c9e", "\u5448", "\u5824", "\u5e1d", "\u5ef7", "\u62b5", "\u7de0",
             "\u8247", "\u8a02", "\u9013", "\u90b8", "\u6ce5", "\u6458", "\u6ef4",
             "\u54f2", "\u5fb9", "\u64a4", "\u8fed", "\u6dfb", "\u6bbf", "\u5410",
             "\u5857", "\u6597", "\u6e21", "\u9014", "\u5974", "\u6012", "\u5012",
             "\u51cd", "\u5510", "\u5854", "\u60bc", "\u642d", "\u6843", "\u68df",
             "\u76d7", "\u75d8", "\u7b52", "\u5230", "\u8b04", "\u8e0f", "\u9003",
             "\u900f", "\u9676", "\u9a30", "\u95d8", "\u6d1e", "\u80f4", "\u5ce0",
             "\u533f", "\u7763", "\u7be4", "\u51f8", "\u7a81", "\u5c6f", "\u8c5a",
             "\u66c7", "\u920d", "\u7e04", "\u8edf", "\u5c3c", "\u5f10", "\u5982",
             "\u5c3f", "\u598a", "\u5fcd", "\u5be7", "\u732b", "\u7c98", "\u60a9",
             "\u6fc3", "\u628a", "\u8987", "\u5a46", "\u5ec3", "\u6392", "\u676f",
             "\u8f29", "\u57f9", "\u5a92", "\u8ce0", "\u966a", "\u4f2f", "\u62cd",
             "\u6cca", "\u8236", "\u8584", "\u8feb", "\u6f20", "\u7206", "\u7e1b",
             "\u808c", "\u9262", "\u9aea", "\u4f10", "\u7f70", "\u629c", "\u95a5",
             "\u4f34", "\u5e06", "\u642c", "\u7554", "\u7e41", "\u822c", "\u85e9",
             "\u8ca9", "\u7bc4", "\u7169", "\u9812", "\u76e4", "\u86ee", "\u5351",
             "\u5983", "\u5f7c", "\u6249", "\u62ab", "\u6ccc", "\u75b2", "\u7891",
             "\u7f77", "\u88ab", "\u907f", "\u5c3e", "\u5fae", "\u5339", "\u59eb",
             "\u6f02", "\u63cf", "\u82d7", "\u6d5c", "\u8cd3", "\u983b", "\u654f",
             "\u74f6", "\u6016", "\u6276", "\u6577", "\u666e", "\u6d6e", "\u7b26",
             "\u8150", "\u819a", "\u8b5c", "\u8ce6", "\u8d74", "\u9644", "\u4fae",
             "\u821e", "\u5c01", "\u4f0f", "\u5e45", "\u8986", "\u6255", "\u6cb8",
             "\u5674", "\u58b3", "\u61a4", "\u7d1b", "\u96f0", "\u4e19", "\u4f75",
             "\u5840", "\u5e63", "\u5f0a", "\u67c4", "\u58c1", "\u7656", "\u504f",
             "\u904d", "\u8217", "\u6355", "\u7a42", "\u52df", "\u6155", "\u7c3f",
             "\u5023", "\u4ff8", "\u5949", "\u5cf0", "\u5d29", "\u62b1", "\u6ce1",
             "\u7832", "\u7e2b", "\u80de", "\u82b3", "\u8912", "\u90a6", "\u98fd",
             "\u4e4f", "\u508d", "\u5256", "\u574a", "\u59a8", "\u5e3d", "\u5fd9",
             "\u623f", "\u67d0", "\u5192", "\u7d21", "\u80aa", "\u81a8", "\u8b00",
             "\u50d5", "\u58a8", "\u64b2", "\u6734", "\u6ca1", "\u5800", "\u5954",
             "\u7ffb", "\u51e1", "\u76c6", "\u6469", "\u78e8", "\u9b54", "\u9ebb",
             "\u57cb", "\u819c", "\u53c8", "\u62b9", "\u7e6d", "\u6162", "\u6f2b",
             "\u9b45", "\u5cac", "\u5999", "\u7720", "\u77db", "\u9727", "\u5a7f",
             "\u5a18", "\u9298", "\u6ec5", "\u514d", "\u8302", "\u5984", "\u731b",
             "\u76f2", "\u7db2", "\u8017", "\u9ed9", "\u623b", "\u7d0b", "\u5301",
             "\u5384", "\u8e8d", "\u67f3", "\u6109", "\u7652", "\u8aed", "\u552f",
             "\u5e7d", "\u60a0", "\u6182", "\u7336", "\u88d5", "\u8a98", "\u96c4",
             "\u878d", "\u4e0e", "\u8a89", "\u5eb8", "\u63da", "\u63fa", "\u64c1",
             "\u6eb6", "\u7aaf", "\u8b21", "\u8e0a", "\u6291", "\u7ffc", "\u7f85",
             "\u88f8", "\u983c", "\u96f7", "\u7d61", "\u916a", "\u6b04", "\u6feb",
             "\u540f", "\u5c65", "\u75e2", "\u96e2", "\u786b", "\u7c92", "\u9686",
             "\u7adc", "\u616e", "\u865c", "\u4e86", "\u50da", "\u5bee", "\u6dbc",
             "\u731f", "\u7642", "\u7ce7", "\u9675", "\u502b", "\u5398", "\u96a3",
             "\u5841", "\u6d99", "\u7d2f", "\u52b1", "\u9234", "\u96b7", "\u96f6",
             "\u970a", "\u9e97", "\u9f62", "\u66a6", "\u52a3", "\u70c8", "\u88c2",
             "\u5ec9", "\u604b", "\u932c", "\u7089", "\u9732", "\u5eca", "\u697c",
             "\u6d6a", "\u6f0f", "\u90ce", "\u8cc4", "\u60d1", "\u67a0", "\u6e7e",
             "\u8155")

  # Hiragana List.
  hiragana <- c("\u3042", "\u3044", "\u3046", "\u3048", "\u304a",
                "\u304b", "\u304d", "\u304f", "\u3051", "\u3053",
                "\u3055", "\u3057", "\u3059", "\u305b", "\u305d",
                "\u305f", "\u3061", "\u3064", "\u3066", "\u3068",
                "\u306a", "\u306b", "\u306c", "\u306d", "\u306e",
                "\u306f", "\u3072", "\u3075", "\u3078", "\u307b",
                "\u307e", "\u307f", "\u3080", "\u3081", "\u3082",
                "\u3084", "\u3086", "\u3088",
                "\u3089", "\u308a", "\u308b", "\u308c", "\u308d",
                "\u308f", "\u3090", "\u3046", "\u3091", "\u3092",
                "\u3093",
                "\u30f4",
                "\u304c", "\u304e", "\u3050", "\u3052", "\u3054",
                "\u3056", "\u3058", "\u305a", "\u305c", "\u305e",
                "\u3060", "\u3062", "\u3065", "\u3067", "\u3069",
                "\u3070", "\u3073", "\u3076", "\u3079", "\u307c",
                "\u3041", "\u3043", "\u3045", "\u3047", "\u3049",
                "\u3063",
                "\u3083", "\u3085", "\u3087",
                "\u308e")

  if(moji == "kanji"){
    sapply(rep(size, size), function(size, length, replace){
      paste0(sample(kanji, size = length, replace = replace), collapse = "")
    }, length = length, replace = replace)
  }
  else if(moji == "hiragana"){
    sapply(rep(size, size), function(size, length, replace){
      paste0(sample(hiragana, size = length, replace = replace), collapse = "")
    }, length = length, replace = replace)
  }
}
