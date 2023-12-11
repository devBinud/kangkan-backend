// const productModel = require('../../model/product');
const db = require("../../db");
const multer = require('multer');
const path = require('path');

/*
master_categories: category_id	category_name	parent_category_id
master_gst_details: gst_id	product_id	hsn	igst	cgst	sgst	other	
master_products: product_id	product_code	name	description MRP	brand_id	category_id	is_active
product_inventory: pinv_id	product_id	quantity	rate	purchase_date	mfg_date	exp_date	
product_current_stock: id	product_id	available_stock 	updated_at	threshold_limit
product_image: id	product_id	image	arrangement_id	
product_details: id	product_id	sub_heading	sub_description	
*/
 
// Set up disk storage with Multer
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/product'); // Specify the destination directory
  },
  filename: function (req, file, cb) {
    // Generate a unique filename for each uploaded file
    cb(null, file.fieldname + '-' + Date.now() + path.extname(file.originalname));
  },
});

// Initialize multer with the configured storage engine
const upload = multer({ storage: storage });

/*-----------------------------------------------
                product category
------------------------------------------------*/
//get
const addProductCategoryPage = (req,res)=>{
  db.query('CALL GetCategoryHierarchy()', (error, results) => {
    if (error) throw error;
    console.log({ categories: results[0] })
    res.render('pages/addCategory',  { categories: results[0] });
});
}

// CREATE (POST) 
const addProductCategory = (req, res) => {
    const { category_name, parent_category_id } = req.body;
    // console.log(req.body);
    const sql = 'INSERT INTO master_categories (category_name,parent_category_id) VALUES (?,?)';
    db.query(sql, [category_name, parent_category_id], (err, result) => {
      if (err) throw err;
      res.json({ message: 'Product Category created successfully', id: result[0] });
    });
  };
  
  // READ (GET) 
  const getProductCategoryAll = (req, res) => {
    db.query('CALL GetCategoryHierarchy()', (error, results) => {
        if (error) throw error;
        console.log({ categories: results[0] })
        res.render('pages/get-category',  { categories: results[0] });
    });
  };

  
  // UPDATE (PUT) 
//   const updateProductCategory = (req, res) => {
//     const userId = req.params.id;
//     const { name, email } = req.body;
//     const sql = 'CALL UpdateUser(?, ?, ?)';
//     db.query(sql, [userId, name, email], (err) => {
//       if (err) throw err;
//       res.json({ message: 'User updated successfully' });
//     });
//   };
/*-----------------------------------------------
                !product category
------------------------------------------------*/
/*-----------------------------------------------
                    product
------------------------------------------------*/
// master_products: product_id	product_code	name	description MRP	brand_id	category_id	is_active
// product_image: id	product_id	image	arrangement_id	
// product_details: id	product_id	sub_heading	sub_description	

// CREATE (POST) 
const addProduct = (req, res) => {
  console.log(req.body);
    const { name, description, MRP, category_id, image, arrangement_id, sub_heading, sub_description,product_rating} = req.body;
    const sql = 'CALL CreateProduct(?,?,?,?,?,?,?,?,?)';
    db.query(sql, [name, description, MRP, category_id, 'image', 0, 'sub_heading', 'sub_description',product_rating], (err, result) => {
      if (err) throw err;
      console.log(`id: ${result}`)
      res.json({ message: 'Product created successfully', id: result[0] });
    });
  }; 

  /*
  DELIMITER //

CREATE PROCEDURE CreateProduct(
  IN p_name VARCHAR(255),
  IN p_description TEXT,
  IN p_MRP DECIMAL(10, 2),
  IN p_category_id INT,
  IN p_images JSON,
  IN p_arrangement_ids JSON,
  IN p_sub_heading VARCHAR(255),
  IN p_sub_description TEXT
)
BEGIN
  DECLARE product_id INT;
  DECLARE product_code VARCHAR(50);
  DECLARE rollback_flag BOOLEAN DEFAULT 0;

  -- Declare handler for SQL exceptions
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    SET rollback_flag = 1;

  -- Start the transaction
  START TRANSACTION;

  -- Try block
  BEGIN
    -- Insert into master_product table
    INSERT INTO master_product (name, description, MRP, category_id)
    VALUES (p_name, p_description, p_MRP, p_category_id);

    -- Get the last inserted product_id
    SET product_id = LAST_INSERT_ID();

    -- Generate product_code based on some logic (you can customize this logic)
    SET product_code = CONCAT('PROD', LPAD(product_id, 5, '0'));

    -- Update master_product table with the generated product_code
    UPDATE master_product SET product_code = product_code WHERE id = product_id;

    -- Insert into product_image table for each image and arrangement
    DECLARE i INT DEFAULT 0;
    DECLARE numImages INT;

    -- Assuming p_images and p_arrangement_ids are arrays of the same length
    SET numImages = JSON_LENGTH(p_images);

    WHILE i < numImages DO
      INSERT INTO product_image (product_id, image, arrangement_id)
      VALUES (product_id, JSON_UNQUOTE(JSON_EXTRACT(p_images, CONCAT('$[', i, ']'))), JSON_UNQUOTE(JSON_EXTRACT(p_arrangement_ids, CONCAT('$[', i, ']'))));
      
      SET i = i + 1;
    END WHILE;

    -- Insert into product_details table
    INSERT INTO product_details (product_id, sub_heading, sub_description)
    VALUES (product_id, p_sub_heading, p_sub_description);
  END;

  -- Commit or rollback the transaction based on the rollback flag
  IF (rollback_flag) THEN
    ROLLBACK;
  ELSE
    COMMIT;
    -- Return the inserted product_id and product_code
    SELECT product_id AS insertedId, product_code;
  END IF;

END //

DELIMITER ;

  */
  
  // READ (GET) 
  const getProductAll = (req, res) => {
    const sql = 'CALL GetUser(?)';
    db.query(sql, (err, result) => {
      if (err) throw err;
      res.json(result[0][0]);
    });
  };

  const getProductById = (req, res) => {
    const productId = req.params.id;
    const sql = 'CALL GetUser(?)';
    db.query(sql, [productId], (err, result) => {
      if (err) throw err;
      res.json(result[0][0]);
    });
  };
  
  // UPDATE (PUT) 
//   const updateProduct = (req, res) => {
//     const userId = req.params.id;
//     const { name, email } = req.body;
//     const sql = 'CALL UpdateUser(?, ?, ?)';
//     db.query(sql, [userId, name, email], (err) => {
//       if (err) throw err;
//       res.json({ message: 'User updated successfully' });
//     });
//   };
  
  // DELETE 
//   const deleteProduct =  (req, res) => {
//     const userId = req.params.id;
//     const sql = 'CALL DeleteUser(?)';
//     db.query(sql, [userId], (err) => {
//       if (err) throw err;
//       res.json({ message: 'User deleted successfully' });
//     }); 
//   };

/*-----------------------------------------------
                    !product
------------------------------------------------*/
/*-----------------------------------------------
                product inventory
------------------------------------------------*/
// CREATE (POST) 
const addProductToInventory = (req, res) => {
    const { name, email } = req.body;
    const sql = 'CALL CreateUser(?, ?)';
    db.query(sql, [name, email], (err, result) => {
      if (err) throw err;
      res.json({ message: 'User created successfully', id: result[0][0].insertedId });
    });
};
  
  // READ (GET) 
const getProductInventory = (req, res) => {
    const sql = 'CALL GetUser(?)';
    db.query(sql, (err, result) => {
      if (err) throw err;
      res.json(result[0][0]);
    });
};
/*-----------------------------------------------
                !product inventory
------------------------------------------------*/


module.exports = {
    addProduct,
    addProductCategoryPage,
    getProductAll,
    getProductById,
    // updateProduct,
    // deleteProduct,
    addProductCategory,
    getProductCategoryAll,
    addProductToInventory,
    getProductInventory                                                                                                                                                                                                                      
};