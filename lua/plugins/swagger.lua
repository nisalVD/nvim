return {
  "nisalVD/swagger-preview.nvim",
  cmd = { "SwaggerPreview", "SwaggerStop", "SwaggerPreviewStop" },
  build = "npm i",
  opts = {
    port = 8090,
    host = "localhost",
  },
}
