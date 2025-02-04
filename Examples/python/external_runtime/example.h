/* File : example.h */

class Mesh
{
public:
	Mesh(const int value = 0)
	: value_(value) {}
	int value() { return value_;}
private:
	int value_;
};
