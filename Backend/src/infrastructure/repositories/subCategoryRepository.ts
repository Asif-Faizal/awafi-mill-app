import mongoose, { Model } from 'mongoose';
import { BaseRepository } from './baseRepository';
import IsubCategoryRepo from '../../interface/subCategoryInterface/IsubCategoryRepo';
import IsubCategory from '../../domain/entities/subCategorySchema';
import { categoryCreationDTo } from '../../domain/dtos/CategoryDTO'; // Correct import for category DTO
import { LargeDataFetch } from '../../types/commonTypes';

export class SubCategoryRepository extends BaseRepository<IsubCategory> implements IsubCategoryRepo {
  constructor(model: Model<IsubCategory>) {
    super(model);
  }

  // Correct the DTO used in addCategory
  async addCategory(data: categoryCreationDTo): Promise<IsubCategory> {
    return await super.create(data);
  }

  async getAllCategories(page:number,limit:number): Promise<LargeDataFetch> {
    const skip=(page-1)*limit
    const totalCategories = await this.model.countDocuments();
    const category= await this.model.find().sort({priority:1}).skip(skip).limit(limit);
    return{
      data:category,
      totalPages: Math.ceil(totalCategories / limit)
    }
}
async findCategoryName(page: number, limit: number, name: string): Promise<LargeDataFetch> {
  const skip = (page - 1) * limit;
  // Count total categories that match the regex search
  const totalCategories = await this.model.countDocuments({
    name: { $regex: `^${name}`, $options: 'i' } 
  });

  // Fetch categories with prefix matching prioritized
  const categories = await this.model.find({
      name: { $regex: `^${name}`, $options: 'i' } 
    })
    .skip(skip) // Pagination
    .limit(limit) // Limit the number of results
    .exec();
  
  return {
    data: categories,
    totalPages: Math.ceil(totalCategories / limit) 
  };
}


  async getListedCategories(mainCategoryId:mongoose.Types.ObjectId,page:number,limit:number): Promise<LargeDataFetch> {
    const skip=(page-1)*limit
    const totalCategories = await this.model.countDocuments({isListed:true,isDeleted:false,mainCategory:mainCategoryId});
    const category= await this.model.find({isListed:true,isDeleted:false,mainCategory:mainCategoryId}).sort({priority:1}).skip(skip).limit(limit);
    return{
      data:category,
      totalPages: Math.ceil(totalCategories / limit)
    }
  }

  async findByName(name: string): Promise<IsubCategory | null> {
    const regex = new RegExp(`^${name}$`, 'i'); 
    return await super.findOne({ name: regex });
  }
  async findByNameNotId(id:mongoose.Types.ObjectId,name: string): Promise<IsubCategory | null> {
    const regex = new RegExp(`^${name}$`, 'i'); 
    return await super.findOne({
      _id: { $ne: id },  
      name: { $regex: regex }
    });
  }

  async getCategoryById(id: mongoose.Types.ObjectId): Promise<IsubCategory | null> {
    return await super.findById(id);
  }

  // Correct the DTO used in updateCategory
  async updateCategory(id: mongoose.Types.ObjectId, data: Partial<categoryCreationDTo>): Promise<IsubCategory | null> {
    return await super.update(id, data);
  }

  // Correct the return type to boolean
  async deleteCategory(id: mongoose.Types.ObjectId): Promise<boolean> {
    const result = await super.delete(id);
    return result !== null; // Assuming `super.delete` returns null when no document is found
  }
}

