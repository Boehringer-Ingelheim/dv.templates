test_that("hello greets the entity", {
  result <- hello("foo")
  expected <- "Hello, Foo."
  expect_identical(result, expected)
})

test_that(
  vdoc[["add_spec"]]("my test description", specs$a_spec),
  {
    expect_true(TRUE)
  }
)
