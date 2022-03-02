package validators_test

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/ruben-gp/helm3-unittest/unittest/common"
	. "github.com/ruben-gp/helm3-unittest/unittest/validators"
)

func TestIsNullValidatorWhenOk(t *testing.T) {
	doc := "a:"
	manifest := makeManifest(doc)

	v := IsNullValidator{"a"}
	pass, diff := v.Validate(&ValidateContext{
		Docs: []common.K8sManifest{manifest},
	})
	assert.True(t, pass)
	assert.Equal(t, []string{}, diff)
}

func TestIsNullValidatorWhenNegativeAndOk(t *testing.T) {
	doc := "a: 0"
	manifest := makeManifest(doc)

	v := IsNullValidator{"a"}
	pass, diff := v.Validate(&ValidateContext{
		Docs:     []common.K8sManifest{manifest},
		Negative: true,
	})

	assert.True(t, pass)
	assert.Equal(t, []string{}, diff)
}

func TestIsNullValidatorWhenFail(t *testing.T) {
	doc := "a: A"
	manifest := makeManifest(doc)

	v := IsNullValidator{"a"}
	pass, diff := v.Validate(&ValidateContext{
		Docs: []common.K8sManifest{manifest},
	})

	assert.False(t, pass)
	assert.Equal(t, []string{
		"Path:	a",
		"Expected to be null, got:",
		"	A",
	}, diff)
}

func TestIsNullValidatorWhenNegativeAndFail(t *testing.T) {
	doc := "a:"
	manifest := makeManifest(doc)

	v := IsNullValidator{"a"}
	pass, diff := v.Validate(&ValidateContext{
		Docs:     []common.K8sManifest{manifest},
		Negative: true,
	})

	assert.False(t, pass)
	assert.Equal(t, []string{
		"Path:	a",
		"Expected NOT to be null, got:",
		"	null",
	}, diff)
}
