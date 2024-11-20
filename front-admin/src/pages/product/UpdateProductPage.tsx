import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { Description, Variant } from "../../types/productTypes";
import { Category, subCategory } from "../../types/categoryType";
import categoryapi from "../../api/categoryapi";
import subcategoryapi from "../../api/subcategoryapi";
import productapi from "../../api/productapi";
import { toast } from "react-toastify";
import { z } from "zod"; // Add this import for validation
import ConfirmationDialog from "../../components/ConfirmationDialog";

const MAX_IMAGES = 5;

// Add validation schemas
const descriptionSchema = z.object({
  header: z.string().min(1, "Header is required"),
  content: z.string().min(1, "Content is required"),
});

const variantSchema = z.object({
  weight: z
  .string()
  .min(1, "Weight is required")
  .refine(
    (value) => /^(\d+(\.\d+)?)\s*(gram|piece|mg|stick|g|kg|ml|l)s?$/i.test(value),
    "Weight must be in a valid format (e.g., 10 g, 2 kg, 500 ml)."
  ),
  inPrice: z.string().regex(/^\d+(\.\d{1,2})?$/, "Invalid price format"),
  outPrice: z.string().regex(/^\d+(\.\d{1,2})?$/, "Invalid price format"),
  stockQuantity: z.string().regex(/^\d+$/, "Stock quantity must be a positive integer"),
});

const productSchema = z.object({
  name: z.string().min(1, "Product name is required"),
  category: z.string().min(1, "Category is required"),
  subCategory: z.string().optional(),
  descriptions: z.array(descriptionSchema).min(1, "At least one description is required"),
  variants: z.array(variantSchema).min(1, "At least one variant is required"),
  sku: z.string().min(1, "SKU is required"),
  ean: z.string().min(1, "EAN is required")  // Changed to only require non-empty string
});

const UpdateProductPage: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();

  const [name, setName] = useState("");
  const [descriptions, setDescriptions] = useState<Description[]>([
    { header: "", content: "" },
  ]);
  const [categories, setCategories] = useState<Category[]>([]);
  const [category, setCategory] = useState<Category | null>(null);
  const [subCategories, setSubCategories] = useState<subCategory[]>([]); // Initialize as an empty array
  const [subCategory, setSubCategory] = useState<Category | null>(null);
  const [images, setImages] = useState<(string | File | null)[]>(Array(MAX_IMAGES).fill(null));
  const [variants, setVariants] = useState<Variant[]>([
    { weight: "", inPrice: "", outPrice: "", stockQuantity: "" },
  ]);
  const [isLoading, setIsLoading] = useState(true);
  const [imageLoading, setImageLoading] = useState<boolean[]>(Array(MAX_IMAGES).fill(false)); // New state
  const [errors, setErrors] = useState<Record<string, string>>({});
  const [sku, setSku] = useState("");
  const [ean, setEan] = useState("");
  const [showDialog, setshowDialog] = useState(false);
  const[index,setIndex]=useState<number | null>(null)
  

  useEffect(() => {
    const fetchData = async () => {
      try {
        const [categoryResponse, productResponse] = await Promise.all([
          categoryapi.fetchAllListedCategories(),
          productapi.fetchProductById(id!),
        ]);

        if (categoryResponse.status === 200) {
          setCategories(categoryResponse.data.data);
        }

        if (productResponse.status === 200) 
          {
          const product = productResponse.data;
          setName(product.name);
          setDescriptions(product.descriptions || [{ header: "", content: "" }]);
          setCategory(product.MainCategoryData[0] || null);
          setSubCategory(product.SubCategoryData[0] || null);
          // Convert numeric values to strings when setting variants
          setVariants(product.variants?.map((variant: any) => ({
            weight: variant.weight || "",
            inPrice: variant.inPrice?.toString() || "",
            outPrice: variant.outPrice?.toString() || "",
            stockQuantity: variant.stockQuantity?.toString() || ""
          })) || [{ weight: "", inPrice: "", outPrice: "", stockQuantity: ""}]);
          setSku(product.sku || "");
          setEan(product.ean || "");

          const existingImages = product.images || [];
          setImages([
            ...existingImages,
            ...Array(MAX_IMAGES - existingImages.length).fill(null),
          ]);

          if (product.category) {
            const subCategoriesResponse = await subcategoryapi.fetchAllListedCategories(product.category._id);
            if (subCategoriesResponse.status === 200) {
              setSubCategories(subCategoriesResponse.data.data);
            }
          }
        }
      } catch (error) {
        console.error("Error fetching data:", error);
        toast.error("Failed to load product data");
      } finally {
        setIsLoading(false);
      }
    };

    if (id) {
      fetchData();
    }
  }, [id]);

  useEffect(() => {
    const fetchSubCategories = async () => {
      if (category?._id) {
        try {
          const response = await subcategoryapi.fetchAllListedCategories(category._id);
          if (response.status === 200) {
            setSubCategories(response.data.data);
          }
        } catch (error) {
          console.error("Error fetching subcategories:", error);
          toast.error("Failed to load subcategories");
        }
      } else {
        setSubCategories([]);
      }
    };

    fetchSubCategories();
  }, [category]);

  const handleImageChange = (index: number, file: File | null) => {
    const newImages = [...images];
    newImages[index] = file || null;
    setImages(newImages);
  };

  const handleImageUpload = async (index: number) => {
    setImageLoading((prevLoading) => {
      const newLoading = [...prevLoading];
      newLoading[index] = true;
      return newLoading;
    });

    const image = images[index];
    if (image instanceof File && id) {
      const formData = new FormData();
      formData.append("image", image);
      try {
        const response = await productapi.updateProductImage(id, formData, index);
        if (response.status === 200) {
          const newImages = [...images];
          newImages[index] = response.data;
          setImages(newImages);
          toast.success("Image updated successfully");
        }
      } catch (error) {
        console.error("Error updating image:", error);
        toast.error("Failed to update image");
      }finally{
        setImageLoading((prevLoading) => {
          const newLoading = [...prevLoading];
          newLoading[index] = false;
          return newLoading;
        });
      }
    }
  };


  const handleImageDelete = async (index: number) => {
    console.log("ind",index)
    setIndex(index)
    setshowDialog(true);
  };
  
  const confirmImageDeletion = async () => {
    if (typeof index === "number") {

    const response = await productapi.deletImage(id!, index);
    if (response.status === 200) {
      const newImages = [...images];
      newImages[index] = '';
      setImages(newImages);
      toast.success("Image deleted successfully");
    } else {
      toast.error("Failed to delete image");
    }
  }
  else{
    toast.error("index not found")
  }
  setshowDialog(false);
    
  };
  


  const handleAddDescription = () => {
    setDescriptions([...descriptions, { header: "", content: "" }]);
  };

  const handleRemoveDescription = (index: number) => {
    setDescriptions(descriptions.filter((_, i) => i !== index));
  };

  const handleDescriptionChange = (
    index: number,
    field: "header" | "content",
    value: string
  ) => {
    const newDescriptions = [...descriptions];
    newDescriptions[index][field] = value;
    setDescriptions(newDescriptions);
  };

  const handleAddVariant = () =>
    setVariants([
      ...variants,
      { weight: "", inPrice: "", outPrice: "", stockQuantity: "" },
    ]);

  const handleRemoveVariant = (index: number) =>
    setVariants(variants.filter((_, i) => i !== index));

  const validateForm = () => {
    try {
      productSchema.parse({
        name,
        category: category?._id,
        subCategory: subCategory?._id,
        descriptions,
        variants,
        sku,
        ean,
      });
      setErrors({});
      return true;
    } catch (error) {
      if (error instanceof z.ZodError) {
        const newErrors: Record<string, string> = {};
        error.errors.forEach((err) => {
          newErrors[err.path.join('.')] = err.message;
        });
        setErrors(newErrors);
      }
      return false;
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!validateForm()) {
      toast.error("Please correct the errors before submitting");
      return;
    }

    const productData = {
      name,
      category: category?._id,
      subCategory: subCategory?._id,
      descriptions,
      variants: variants.map(variant => ({
        ...variant,
        inPrice: variant.inPrice.toString(),
        outPrice: variant.outPrice.toString(),
        stockQuantity: variant.stockQuantity.toString()
      })),
      sku,
      ean,
    };

    try {
      const response = await productapi.updateProduct(productData, id!);
      if (response.status === 200) {
        toast.success("Product updated successfully");
        navigate("/products");
      }
    } catch (error) {
      console.error("Error updating product:", error);
      toast.error("Failed to update product");
    }
  };

  if (isLoading) {
    return (
      <div className="flex justify-center items-center h-screen">
  <div className="animate-spin rounded-full h-16 w-16 border-t-4 border-gray-500"></div>
</div>
    );
  }

  return (
    <div className="flex flex-col gap-10 w-full">
      <h1 className="text-3xl font-bold mb-6 text-gray-800">Update Product</h1>
      <form onSubmit={handleSubmit} className="space-y-8">
      <div className="bg-white shadow-lg rounded-lg p-6">
  <h2 className="text-2xl font-semibold mb-6 text-gray-700">Images</h2>
  <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-6">
    {images.map((image, index) => (
      <div key={index} className="flex flex-col items-center">
        <div className="w-32 h-32 border-2 border-dashed border-gray-300 rounded-lg flex items-center justify-center overflow-hidden bg-gray-50">
          {image ? (
            typeof image === "string" ? (
              <img
                src={image}
                id={`image-${index}`}
                alt={`Product ${index + 1}`}
                className="w-full h-full object-cover"
              />
            ) : (
              <img
                src={URL.createObjectURL(image)}
                id={`image-${index}`}
                alt={`Product ${index + 1}`}
                className="w-full h-full object-cover"
              />
            )
          ) : (
            <span className="text-gray-400">No image</span>
          )}
        </div>
        <input
          type="file"
          accept="image/*"
          onChange={(e) => handleImageChange(index, e.target.files?.[0] || null)}
          className="hidden"
          id={`image-input-${index}`}
        />
        <label
          htmlFor={`image-input-${index}`}
          className="mt-3 cursor-pointer text-sm font-medium text-indigo-600 hover:text-indigo-800"
        >
          {image ? 'Change' : 'Add Image'}
        </label>
        {image instanceof File && (
          <div className="mt-2">
            <button
              type="button"
              onClick={() => handleImageUpload(index)}
              className="text-xs font-medium text-green-600 hover:text-green-800"
              disabled={imageLoading[index]} // Disable if loading
            >
              {imageLoading[index] ? (
                <span className="flex items-center">
                  <svg
                    className="animate-spin h-4 w-4 text-green-600"
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none"
                    viewBox="0 0 24 24"
                  >
                    <circle
                      className="opacity-25"
                      cx="12"
                      cy="12"
                      r="10"
                      stroke="currentColor"
                      strokeWidth="4"
                    ></circle>
                    <path
                      className="opacity-75"
                      fill="currentColor"
                      d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"
                    ></path>
                  </svg>
                  <span className="ml-2">Uploading...</span>
                </span>
              ) : (
                'Upload'
              )}
            </button>
          </div>
        )}
        {/* Delete Button */}
        {image &&
        <button
          type="button"
          onClick={() => handleImageDelete(index)}
          className="mt-2 text-xs font-medium text-red-600 hover:text-red-800"
        >
          Delete
        </button>} 
      </div>
    ))}
  </div>
</div>


        <div className="bg-white shadow-lg rounded-lg p-6">
  <h2 className="text-2xl font-semibold mb-6 text-gray-700">Basic Information</h2>
  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
    {/* Product Name Input */}
    <div className="flex flex-col">
      <label htmlFor="productName" className="block text-sm font-medium text-gray-700 mb-1">
        Product Name
      </label>
      <div className="flex flex-col-reverse">
      <label htmlFor="productName" className="block text-sm font-medium text-gray-700 mb-1">
        Product Name
      </label>
        <input
          id="productName"
          type="text"
          value={name}
          placeholder="Product Name"
          onChange={(e) => setName(e.target.value)}
          className={`bg-white border ${errors['name'] ? 'border-red-500' : 'border-gray-300'} text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5`}
          required
        />
    
      </div>
    </div>

    {/* Main Category Select */}
    <div>
      <label htmlFor="category" className="block text-sm font-medium text-gray-700 mb-1">
        Main Category
      </label>
      <select
        id="category"
        value={category?._id || ""}
        onChange={(e) => {
          const selectedCategory = categories.find(cat => cat._id === e.target.value);
          setCategory(selectedCategory || null);
          setSubCategory(null);
        }}
        className="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
        required
      >
        <option value="">{category ? category.name : "Select a main category"}</option>
        {categories.map((cat) => (
          <option key={cat._id} value={cat._id}>
            {cat.name}
          </option>
        ))}
      </select>
    </div>

    {/* Sub Category Select */}
    <div>
      <label htmlFor="subCategory" className="block text-sm font-medium text-gray-700 mb-1">
        Sub Category
      </label>
      <select
        id="subCategory"
        value={subCategory?._id || ""}
        onChange={(e) => {
          const selectedSubCategory = subCategories.find(subCat => subCat._id === e.target.value);
          setSubCategory(selectedSubCategory || null);
        }}
        className="bg-white border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5"
        disabled={!category}
      >
        <option value="">{subCategory ? subCategory.name : "Select a sub category"}</option>
        {Array.isArray(subCategories) && subCategories.map((subCat) => (
          <option key={subCat._id} value={subCat._id}>
            {subCat.name}
          </option>
        ))}
      </select>
    </div>
  </div>
</div>

<div className="bg-white shadow-lg rounded-lg p-6">
          <h2 className="text-2xl font-semibold mb-6 text-gray-700">Product Identifiers</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {/* SKU Input */}
            <div className="flex flex-col">
              <label htmlFor="sku" className="block text-sm font-medium text-gray-700 mb-1">
                SKU (Stock Keeping Unit)
              </label>
              <input
                id="sku"
                type="text"
                value={sku}
                onChange={(e) => setSku(e.target.value)}
                className={`bg-white border ${errors['sku'] ? 'border-red-500' : 'border-gray-300'} text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5`}
                required
              />
              {errors['sku'] && <p className="mt-1 text-sm text-red-500">{errors['sku']}</p>}
            </div>

            {/* EAN Input */}
            <div className="flex flex-col">
              <label htmlFor="ean" className="block text-sm font-medium text-gray-700 mb-1">
                EAN (European Article Number)
              </label>
              <input
                id="ean"
                type="text"
                value={ean}
                onChange={(e) => setEan(e.target.value)}
                className={`bg-white border ${errors['ean'] ? 'border-red-500' : 'border-gray-300'} text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5`}
                required
              />
              {errors['ean'] && <p className="mt-1 text-sm text-red-500">{errors['ean']}</p>}
            </div>
          </div>
        </div>


        <div className="bg-white shadow-lg rounded-lg p-6">
  <h2 className="text-2xl font-semibold mb-6 text-gray-700">Descriptions</h2>
  {descriptions.map((desc, index) => (
    <div key={index} className="mb-6 p-4 bg-gray-50 rounded-lg">
      <div className="flex flex-col mb-4">
        <label className="text-gray-600 mb-2 text-sm" htmlFor={`header-${index}`}>
          Header
        </label>
        <input
          id={`header-${index}`}
          type="text"
          placeholder="Header"
          value={desc.header}
          onChange={(e) => handleDescriptionChange(index, "header", e.target.value)}
          className={`peer outline-none px-4 py-2 border ${errors[`descriptions.${index}.header`] ? 'border-red-500' : 'border-gray-300'} rounded-lg shadow-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition duration-200 text-sm`}
        />
        {errors[`descriptions.${index}.header`] && <p className="mt-1 text-sm text-red-500">{errors[`descriptions.${index}.header`]}</p>}
      </div>
      <div className="flex flex-col mb-4">
        <label className="text-gray-600 mb-2 text-sm" htmlFor={`content-${index}`}>
          Content
        </label>
        <textarea
          id={`content-${index}`}
          placeholder="Content"
          value={desc.content}
          onChange={(e) => handleDescriptionChange(index, "content", e.target.value)}
          className={`block w-full px-4 py-2 border ${errors[`descriptions.${index}.content`] ? 'border-red-500' : 'border-gray-300'} rounded-lg shadow-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition duration-200 text-sm`}
          rows={4}
        />
        {errors[`descriptions.${index}.content`] && <p className="mt-1 text-sm text-red-500">{errors[`descriptions.${index}.content`]}</p>}
      </div>
      <button
        type="button"
        onClick={() => handleRemoveDescription(index)}
        className="mt-2 text-sm font-medium text-red-600 hover:text-red-800"
      >
        Remove Description
      </button>
    </div>
  ))}
  <button
    type="button"
    onClick={handleAddDescription}
    className="mt-4 inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-black focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
  >
    Add Description
  </button>
</div>

<div className="bg-white shadow-lg rounded-lg p-6">
  <h2 className="text-2xl font-semibold mb-6 text-gray-700">Variants</h2>
  {variants.map((variant, index) => (
    <div key={index} className="mb-6 p-4 bg-gray-50 rounded-lg">
      <div className="grid grid-cols-4 gap-4">
        <div className="flex flex-col">
          <label className="text-gray-600 mb-2 text-sm" htmlFor={`weight-${index}`}>
            Weight/Unit
          </label>
          <input
            id={`weight-${index}`}
            type="text"
            placeholder="Weight"
            value={variant.weight}
            onChange={(e) =>
              setVariants(variants.map((v, i) =>
                i === index ? { ...v, weight: e.target.value } : v
              ))
            }
            className={`bg-white border ${errors[`variants.${index}.weight`] ? 'border-red-500' : 'border-gray-300'} text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5`}
          />
          {errors[`variants.${index}.weight`] && <p className="mt-1 text-sm text-red-500">{errors[`variants.${index}.weight`]}</p>}
        </div>
        
        <div className="flex flex-col">
          <label className="text-gray-600 mb-2 text-sm" htmlFor={`inPrice-${index}`}>
            In Price
          </label>
          <input
            id={`inPrice-${index}`}
            type="text"
            placeholder="In Price"
            value={variant.inPrice}
            onChange={(e) =>
              setVariants(
                variants.map((v, i) =>
                  i === index ? { ...v, inPrice: e.target.value } : v
                )
              )
            }
            className={`bg-white border ${errors[`variants.${index}.inPrice`] ? 'border-red-500' : 'border-gray-300'} text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5`}
          />
          {errors[`variants.${index}.inPrice`] && <p className="mt-1 text-sm text-red-500">{errors[`variants.${index}.inPrice`]}</p>}
        </div>

        <div className="flex flex-col">
          <label className="text-gray-600 mb-2 text-sm" htmlFor={`outPrice-${index}`}>
            Out Price
          </label>
          <input
            id={`outPrice-${index}`}
            type="text"
            placeholder="Out Price"
            value={variant.outPrice}
            onChange={(e) =>
              setVariants(
                variants.map((v, i) =>
                  i === index ? { ...v, outPrice: e.target.value } : v
                )
              )
            }
            className={`bg-white border ${errors[`variants.${index}.outPrice`] ? 'border-red-500' : 'border-gray-300'} text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5`}
          />
          {errors[`variants.${index}.outPrice`] && <p className="mt-1 text-sm text-red-500">{errors[`variants.${index}.outPrice`]}</p>}
        </div>

        <div className="flex flex-col">
          <label className="text-gray-600 mb-2 text-sm" htmlFor={`stockQuantity-${index}`}>
            Stock Quantity
          </label>
          <input
            id={`stockQuantity-${index}`}
            type="text"
            placeholder="Stock quantity"
            value={variant.stockQuantity}
            onChange={(e) =>
              setVariants(variants.map((v, i) =>
                i === index ? { ...v, stockQuantity: e.target.value } : v
              ))
            }
            className={`bg-white border ${errors[`variants.${index}.stockQuantity`] ? 'border-red-500' : 'border-gray-300'} text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full p-2.5`}
          />
          {errors[`variants.${index}.stockQuantity`] && <p className="mt-1 text-sm text-red-500">{errors[`variants.${index}.stockQuantity`]}</p>}
        </div>
      </div>
      <button
        type="button"
        onClick={() => handleRemoveVariant(index)}
        className="mt-3 text-sm font-medium text-red-600 hover:text-red-800"
      >
        Remove Variant
      </button>
    </div>
  ))}
  <button
    type="button"
    onClick={handleAddVariant}
    className="mt-3 inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md shadow-sm text-white bg-black focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
  >
    Add Variant
  </button>
</div>

       
        <div className="flex justify-end">
          <button
            type="submit"
            className="inline-flex items-center px-6 py-3 border border-transparent text-base font-medium rounded-md shadow-sm text-white bg-black focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
          >
            Update Product
          </button>
        </div>
      </form>
      {showDialog && (
  <ConfirmationDialog
    message="Are you sure you want to delete this image?"
    confirmButtonLabel="Yes"
    cancelButtonLabel="No"
    onConfirm={confirmImageDeletion}
    onCancel={() => {setshowDialog(false)}}
  />
)}

    
    </div>
 );
};

export default UpdateProductPage;
