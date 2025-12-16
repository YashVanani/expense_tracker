const Expense = require('../models/Expense');

exports.getExpenses = async (req, res) => {
  try {
    const expenses = await Expense.find({ user: req.user._id })
      .sort({ date: -1 })
      .select('-__v');

    const totalAmount = expenses.reduce((sum, expense) => sum + expense.amount, 0);

    res.status(200).json({
      success: true,
      count: expenses.length,
      totalAmount,
      expenses
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message || 'Error fetching expenses'
    });
  }
};

exports.getExpense = async (req, res) => {
  try {
    const expense = await Expense.findOne({
      _id: req.params.id,
      user: req.user._id
    }).select('-__v');

    if (!expense) {
      return res.status(404).json({
        success: false,
        message: 'Expense not found'
      });
    }

    res.status(200).json({
      success: true,
      expense
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message || 'Error fetching expense'
    });
  }
};

exports.createExpense = async (req, res) => {
  try {
    const { title, amount, category, date } = req.body;

    if (!title || !amount || !category) {
      return res.status(400).json({
        success: false,
        message: 'Please provide title, amount, and category'
      });
    }

    const expense = await Expense.create({
      title,
      amount: parseFloat(amount),
      category,
      date: date ? new Date(date) : new Date(),
      user: req.user._id
    });

    res.status(201).json({
      success: true,
      message: 'Expense created successfully',
      expense
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message || 'Error creating expense'
    });
  }
};

exports.updateExpense = async (req, res) => {
  try {
    const { title, amount, category, date } = req.body;

    let expense = await Expense.findOne({
      _id: req.params.id,
      user: req.user._id
    });

    if (!expense) {
      return res.status(404).json({
        success: false,
        message: 'Expense not found'
      });
    }

    if (title) expense.title = title;
    if (amount !== undefined) expense.amount = parseFloat(amount);
    if (category) expense.category = category;
    if (date) expense.date = new Date(date);

    await expense.save();

    res.status(200).json({
      success: true,
      message: 'Expense updated successfully',
      expense
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message || 'Error updating expense'
    });
  }
};

exports.deleteExpense = async (req, res) => {
  try {
    const expense = await Expense.findOne({
      _id: req.params.id,
      user: req.user._id
    });

    if (!expense) {
      return res.status(404).json({
        success: false,
        message: 'Expense not found'
      });
    }

    await Expense.findByIdAndDelete(req.params.id);

    res.status(200).json({
      success: true,
      message: 'Expense deleted successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message || 'Error deleting expense'
    });
  }
};

exports.getSummary = async (req, res) => {
  try {
    const expenses = await Expense.find({ user: req.user._id });

    const totalAmount = expenses.reduce((sum, expense) => sum + expense.amount, 0);

    const categoryBreakdown = expenses.reduce((acc, expense) => {
      const category = expense.category;
      if (!acc[category]) {
        acc[category] = 0;
      }
      acc[category] += expense.amount;
      return acc;
    }, {});

    res.status(200).json({
      success: true,
      summary: {
        totalExpenses: expenses.length,
        totalAmount,
        categoryBreakdown
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message || 'Error fetching summary'
    });
  }
};

