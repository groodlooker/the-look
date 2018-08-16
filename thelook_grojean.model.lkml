connection: "thelook_events"

# include all the views
include: "*.view"

datagroup: transaction_datagroup {
  sql_trigger: SELECT MAX(created_date) FROM order_items;;
  max_cache_age: "4 hours"
}

# persist_with: transaction_datagroup

explore: bsandell {}

explore: company_list {}

explore: distribution_centers {}

explore: events {
  sql_always_where: ${created_date} >= '01-01-2018' ;;
  join: users {
    view_label: "User Information"
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  persist_with: transaction_datagroup
  always_filter: {
    filters: {
      field: created_year
      value: "2017, 2018"
    }
  }
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
    fields: [users.email, users.first_name, users.last_name, users.state, users.city, users.zip]
  }

  join: inventory_items {
    view_label: "Inventory & Distribution"
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    view_label: "Inventory & Distribution"
    type: left_outer
    sql_on: ${inventory_items.product_distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: users {}

explore: known_events {
  from: events
  join: users {
    sql_on: ${known_events.user_id} = ${users.id} ;;
    relationship: many_to_one
    type: inner
  }
}
