view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: total_sale_price {
    type: sum
    label: "Total Order Amount"
    sql: ${sale_price} ;;
  }

  dimension: created_ty {
    hidden: yes
    type: yesno
    sql: ${created_year} = 2018 ;;
  }

  dimension: created_ly {
    hidden: yes
    type: yesno
    sql: ${created_year} = 2017 ;;
  }

  measure: sale_price_ty {
    type: sum
    value_format_name: usd
    label: "This Year Sales"
    filters: {
      field: created_ty
      value: "yes"
    }
    sql: ${sale_price} ;;
  }

  measure: sale_price_ly {
    type: sum
    value_format_name: usd
    label: "Last Year Sales"
    filters: {
      field: created_ly
      value: "yes"
    }
    sql: ${sale_price} ;;
  }

  measure: yoy_diff {
    type: number
    label: "Difference in Sales Year Over Year"
    value_format_name: usd
    drill_fields: [inventory_item_id]
    sql: ${sale_price_ty} - ${sale_price_ly} ;;
  }


  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
