#include <iostream>
#include <string>
#include <vector>

using namespace std;

class Block {
private:
	int id;
	char content;

public:
	static int count;
	
	Block();

	Block(char c)
	{
		id = count++;
		content = c;
		Memory::blocks.push_back(*this);
	}
	int getId()
	{
		return id;
	}

	char getContent()
	{
		return content;
	}

	void setContent(char c) {
		content = c;
	}
};

class Memory : public Block {
public:
	static vector<Block> blocks;

	static char getValueAt(int index) {
		return blocks[index].getContent();
	}

	static void clearValueAt(int index)
	{
		blocks[index].setContent('\0');
	}

};

class File: public Block {
private:
	string name;
	Block* first;
	//string content;
	int blocks;
public:
	string retValue;


	File()
	{
		name = "";
	}

	File(string name)
	{
		this->name = name;
	}

	void setName(string name)
	{
		this->name = name;
	}

	string getName()
	{
		return name;
	}

	void setContent(string content)
	{
		blocks = content.size();
		first = new Block(content[0]);
		for (int i = 1; i < blocks; i++) {
			new Block(content[i]);
		}

	}

	string getContent()
	{
		
		int id = first->getId();
		for (int i = id; i < id + blocks; i++) {
			retValue += Memory::getValueAt(i);
		}

		return retValue;
	}

	void clearMemory()
	{
		int id = first->getId();
		for (int i = id; i < id + blocks; i++) {
			Memory::clearValueAt(i);
		}
	}

	File& operator=(const File& right)
	{
		if (this == &right) {
			return *this;
		}

		name = right.name;
		blocks = right.blocks;
		first = new Block(right.first->getContent());
		for (int i = 1; i < blocks; i++) {
			int index = right.first->getId() + i;
			new Block(Memory::getValueAt(index));
		}

		return *this;
	}



};




class Manager: public File {
private:
	vector<File> files;
	bool isFileExists(string name)
	{
		for (File& file : files) {
			if (name == file.getName()) return true;
		}
		return false;
	}

	void createUniqueName(string& name)
	{
		while (isFileExists(name)) {
			name += "1";
		}
	}
public:
	void createFile(string name)
	{
		if (name == "") return;
		if (isFileExists(name)) {
			createUniqueName(name);
		}

		File file(name);
		files.push_back(file);
	}

	void deleteFile(string name)
	{
		for (int i = 0; files.size(); i++) {
			File file = files[i];
			if (file.getName() == name) {
				file.clearMemory();
				files.erase(files.begin() + i);
				return;
			}
		}
	}

	void copyFile(string name)
	{
		File newFile;
		for (File& file : files) {
			if (file.getName() == name) {
				newFile = file;
				newFile.setName(name + "_copy");
				files.push_back(newFile);
				return;
			}
		}

	}

	string readFile(string name)
	{
		for (File& file : files) {
			if (file.getName() == name) {
				return file.getContent();
			}
		}
		return "";
	}

	void writeFile(string name, string content)
	{
		for (File& file : files) {
			if (file.getName() == name) {
				file.setContent(content);
				return;
			}
		}
	}

	void printAllFiles()
	{
		for (File& file : files) {
			std::cout << file.getName() << endl;
		}
	}


};









int main() {
	setlocale(LC_ALL, "Russian");
	Manager manager;

	while (true) {
		cout << "Выберите операцию над файлами" << endl;
		cout << "1) Все файлы" << endl <<
				"2) Создать файл" << endl <<
				"3) Удалить файл" << endl <<
				"4) Запись в файл" << endl <<
				"5) Чтение файла " << endl <<
				"6) Копировать файл " << endl <<
				"7) Закрыть" << endl;

		int input;
		cin >> input;
		string fileName, content;

		switch (input) {
		case 1:
			manager.printAllFiles();
			break;

		case 2:
			cout << "Введите имя файла:" << endl;
			cin >> fileName;
			manager.createFile(fileName);
			break;

		case 3:
			cout << "Введите название файла, который хотите удалить:" << endl;
			cin >> fileName;
			manager.deleteFile(fileName);
			break;

		case 4:
			cout << "Введите имя файла:" << endl;
			cin >> fileName;
			cout << "Введите содержание:" << endl;
			cin >> content;
			manager.writeFile(fileName, content);
			break;

		case 5:
			cout << "Введите название файла, из которого будет происходить чтение:" << endl;
			cin >> fileName;
			cout << manager.readFile(fileName) << endl;
			break;

		case 6:
			cout << "Введите файл, который хотите копировать:" << endl;
			cin >> fileName;
			manager.copyFile(fileName);
			break;

		case 7:
			exit(0);
			break;

		default:
			break;

		}
	}

	return 0;
}