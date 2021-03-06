-- Order - order_items fact table
-- each product in transaction fact (Fact tables for order_items)
insert into warehouse.fct_order_items 
(
	user_id ,
	product_id_surr ,
	seller_id_surr ,
	feedback_id_surr ,
	payment_id_surr,
	order_date ,
	order_approved_date ,
	pickup_date ,
	delivered_date ,
	estimated_time_delivery ,
	pickup_limit_date ,
	order_id ,
	item_number ,
	order_item_status ,
	price ,
	shipping_cost 
) 
(
	select 
		u.user_id,
		p.product_id_surr,
		s.seller_id_surr,
		f.feedback_id_surr,
		pay.payment_id_surr,
		TO_CHAR(o.order_date , 'yyyymmdd')::INT,
		TO_CHAR(o.order_approved_date , 'yyyymmdd')::INT,
		TO_CHAR(o.pickup_date , 'yyyymmdd')::INT,
		TO_CHAR(o.delivered_date , 'yyyymmdd')::INT,
		TO_CHAR(o.estimated_time_delivery , 'yyyymmdd')::INT,
		TO_CHAR(oi.pickup_limit_date , 'yyyymmdd')::INT,
		oi.order_id ,
		oi.order_item_id ,
		o.order_status ,
		oi.price ,
		oi.shipping_cost 
	from live.order_item oi 
		inner join live.order o on oi.order_id = o.order_id 
		inner join (select dim.user_id, dim.user_name from warehouse.dim_user dim where dim.is_current_version = true) u on o.user_name = u.user_name 
		inner join (select df.feedback_id_surr , df.order_id from warehouse.dim_feedback df where df.is_current_version = true) f on o.order_id = f.order_id
		left outer join (select dpay.payment_id_surr, dpay.order_id from warehouse.dim_payment dpay where dpay.is_current_version = true) pay on o.order_id = pay.order_id
		inner join (select dp.product_id_surr , dp.product_id from warehouse.dim_product dp where dp.is_current_version = true) p on oi.product_id = p.product_id
		inner join (select ds.seller_id_surr , ds.seller_id from warehouse.dim_seller ds where ds.is_current_version = true) s on oi.seller_id = s.seller_id
);