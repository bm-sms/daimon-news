User.create!(
  email: "admin@example.com",
  password: "adminpass",
  admin: true
)

User.create!(
  email: "editor@example.com",
  password: "editorpass"
)
