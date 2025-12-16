const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const {
  getExpenses,
  getExpense,
  createExpense,
  updateExpense,
  deleteExpense,
  getSummary
} = require('../controllers/expenseController');

router.use(auth);

router.get('/', getExpenses);
router.get('/summary', getSummary);
router.get('/:id', getExpense);
router.post('/', createExpense);
router.put('/:id', updateExpense);
router.delete('/:id', deleteExpense);

module.exports = router;

