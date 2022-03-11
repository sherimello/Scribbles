import 'models.dart';

/// Fake data used to demo the application.
final fakeData = [
  Todo(id: 'todo-tag-1', description: 'English Project', items: [
    Item(
      id: 'todo-1-item-1',
      description: 'Call Sarah',
    ),
    Item(
      id: 'todo-1-item-2',
      description: 'Research',
    ),
  ]),
  const Todo(
    id: 'todo-tag-2',
    description: 'Homework', items: [],
  ),
  const Todo(
    id: 'todo-tag-3',
    description: 'Like this video', items: [],
  ),
  const Todo(
    id: 'todo-tag-4',
    description: 'Subscribe', items: [],
  ),
  const Todo(
    id: 'todo-tag-5',
    description: 'Learn Riverpod', items: []
  ),
  const Todo(
    id: 'todo-tag-6',
    description: 'Sell Amway products', items: []
  ),
  Todo(id: 'todo-tag-7', description: 'Groceries', items: [
    Item(
      id: 'todo-7-item-1',
      description: 'Cat food',
    ),
    Item(
      id: 'todo-7-item-2',
      description: 'People food',
    ),
    Item(
      id: 'todo-7-item-3',
      description: 'Chip and dip',
    ),
  ]),
  const Todo(
    id: 'todo-tag-8',
    description: 'Play', items: []
  ),
];
