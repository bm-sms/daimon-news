User.create!(
  email: "admin@example.com",
  password: "adminpass",
  role: "admin"
)

User.create!(
  email: "site1-admin@example.com",
  password: "site1pass",
  role: "site_owner"
)

User.create!(
  email: "user1@example.com",
  password: "user1pass",
  role: "user"
)
